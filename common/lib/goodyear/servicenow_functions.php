<?php

define('SN_INCIDENT_STATE_NEW',    1);
define('SN_INCIDENT_STATE_CLOSED', 7);

function soap_functions_and_data($client) {
   $array_functions=$client->__getFunctions();
   println("SOAP functions supported:");
   println("X - DataTypeReturned SoapFunction(DataTypeSent DataInput");
   foreach ($array_functions as $key=>$function) {
     $str_out=sprintf("%2d - %s",$key,$function);
     println($str_out);
   }
   $array_types=$client->__getTypes();
   println("Data Types:");
   foreach ($array_types as $key=>$function) {
     $str_out=sprintf("%2d - %s",$key,$function);
     println($str_out);
   }
}

function open_soapclient($wsdl='',$login,$password,$refresh_wsdl_cache=TRUE) {
  $debug=TRUE;
  $debug=FALSE;

//   $refresh_wsdl_cache=FALSE;
//   $refresh_wsdl_cache=TRUE;    // SET this to TRUE during development otherwise PHP caches WSDL interpretation for 24 hours !!!

  if ($refresh_wsdl_cache) {
    ini_set('soap.wsdl_cache_enabled', '0');
    ini_set('soap.wsdl_cache_ttl', '0');
  }

  if ($debug) {
    println("wsdl='$wsdl'");
  }

  if ($wsdl=='') {
    println("must supply a valid WSDL");
    return(FALSE);
  } 

  // Initialize all options arrays that can be set explicitly over-written in the appropriate cases below
  $proxy = array();
  $options=array('trace'=>1,'soap_version'=>SOAP_1_1);

  if (empty($http_auth)) {
    $http_auth=array('login'=>$login,'password'=>$password);
  }

  $complete_options=$options+$proxy+$http_auth;

  try {
    $soapclient=new SoapClient($wsdl,$complete_options);
    if ($debug) {
      var_dump($soapclient);
      soap_functions_and_data($soapclient);
    }
  } catch (Exception $e) {
    println('Exception');
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
function xml_request_response($soapclient) {
  println('SOAP/XML Request:');
  print(formatXML($soapclient->__getLastRequest()));
  println();
  println('SOAP/XML Response:');
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
    return($obj_doc->saveXML());
}

?>
