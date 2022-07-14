<?php
function soap_functions_and_data($client) {
    $array_functions=$client->__getFunctions();
    echo "<b>SOAP Functions supported:<br /> X - DataTypeReturned SoapFunction(DataTypeSent DataInput)</b><br />\n";
    foreach ($array_functions as $key=>$function) {
        $str_out=sprintf("%2d - %s\n",$key,$function);
        $str_html_out=nl2br(str_replace(' ','&nbsp;',$str_out));
        echo $str_html_out;
    }
    $array_types=$client->__getTypes();
    echo "<b>Data Types:</b><br />\n";
    foreach ($array_types as $key=>$function) {
        $str_out=sprintf("%2d - %s\n",$key,$function);
        $str_html_out=nl2br(str_replace(' ','&nbsp;',$str_out));
        echo $str_html_out;
    }
}

function convertLOB($arr){
  foreach($arr as &$res_row){
	foreach($res_row as &$res_col){
	  if (gettype($res_col)=='object'){
		$res_col=$res_col->load();
	  }
	}
  }
  return $arr;
}
function open_soapclient($app='',$wsdl='',$login,$password,$refresh_wsdl_cache=TRUE) {
  $debug=TRUE;
  $debug=FALSE;

//   $refresh_wsdl_cache=FALSE;
//   $refresh_wsdl_cache=TRUE;    // SET this to TRUE during development otherwise PHP caches WSDL interpretation for 24 hours !!!

  if ($refresh_wsdl_cache) {
    ini_set('soap.wsdl_cache_enabled', '0');
    ini_set('soap.wsdl_cache_ttl', '0');
  }

  if ($debug) {
    println("app='$app'");
    println("wsdl='$wsdl'");
  }

  if ($wsdl=='') {
    println("must supply a valid WSDL");
    return(FALSE);
  } 

   // Initialize all options arrays that can be set explicitly over-written in the appropriate cases below
  $proxy = array();
  $options=array('trace'=>1,'soap_version'=>SOAP_1_1);

  switch($app) {
    case 'sm':
    case 'servicemanager':
      if (empty($http_auth)) {
        $http_auth=array('login'=>$login,'password'=>$password);
	}
    break;

    default:
      println("invalid app selected '$app'");
    break;
  }

  $complete_options=$options+$proxy+$http_auth;

  try {
    $soapclient=new SoapClient($wsdl,$complete_options);
    if ($debug) {
      var_dump($soapclient);
      soap_functions_and_data($soapclient);
    }
  } catch (Exception $e) {
    println('<h2>Exception</h2>');
    println('Error message: ' . $e->getMessage() );
    println('Error code: '    . $e->getCode() );
    println('File and line: ' . $e->getFile() );
    println('Trace: ' . $e->getTraceAsString() );
    soap_functions_and_data($soapclient);
    diagnoseHeaders($soapclient);
    return(FALSE);
  }

  return($soapclient);
}
function diagnose($soapclient) {
  println('<b>SOAP/XML Request / Response Diagnostics</b>');
  println();
  println('<b>XML Request:</b>');
  print(formatXML($soapclient->__getLastRequest()));
  println();
  println('<b>XML Response:</b>');
  $response_xml=$soapclient->__getLastResponse();
  if (isset($response_xml)) {
    print(formatXML($response_xml));
  } else {
      println('.....no response ....');
      println();
      println();
    }
} 
function formatXML($xml) {
    $obj_doc = DOMDocument::loadXML($xml);
    $obj_doc->formatOutput = TRUE; //** we want a nice output
    //return('<pre>'.  htmlentities($obj_doc->saveXML()).'</pre>');
    return($obj_doc->saveXML());
    if (FALSE) return('<span style="font-family: monospace; font-size: 12px;">'.
           nl2br(str_replace(array(' ',"\t"),"&nbsp;",htmlentities($obj_doc->saveXML()))).
           '</span>');
}

function notify_groups($region='NA',$sbu='') {
// Purpose: When a HPSM service is added, the get_notify_groups() function will be called.
//
// $region - defaults to 'NA', one of the following regions below:
// $sbu - defaults to '' 
// returns - array of following notify groups

$region=strtoupper($region);  // just to make sure it's in upper case
$sbu=strtoupper($sbu);
$groups=array();

// Add these notify groups to every service
$groups[]='GY IT Major Corp';
$groups[]='GY IT Major Corp_T';

switch($region) {
   case 'NA':
      $groups[]='GY IT Major NAT';
      $groups[]='GY IT Major NAT_T';
   break;
	
   case 'EMEA': 
      $groups[]='GY IT Major EMEA';
      $groups[]='GY IT Major EMEA_T';
   break;

   case 'LA':
      $groups[]='GY IT Major LA';
      $groups[]='GY IT Major LA_T';
   break;

   case 'AP': 
      $groups[]='GY IT Major AP';
      $groups[]='GY IT Major AP_T';
   break;

   default:
      // do nothing
   break;
}

if ($sbu='RDE&Q') {
   $groups[]='GY IT Major RDEQ';
   $groups[]='GY IT Major RDEQ_T';
}
	
return($groups);
}
?>
