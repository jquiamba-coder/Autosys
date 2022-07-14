<?php

function diagnoseHeaders($soapclient) {
    if (!isset($soapclient)) {
        println('.....no soap client object created ....');
        println();
        println();
        return(FALSE);
    }
    println('<b>SOAP/XML Request / Response Diagnostics</b>');
    println();
    println('<b>SOAP Request Headers:</b>');
    print(formatXML($soapclient->__getLastRequestHeaders()));
    println();
    println('<b>SOAP Response Headers:</b>');
    $response_headers=$soapclient->__getLastResponseHeaders();
    if (isset($response_headers)) {
        print(formatXML($response_headers));
    } else {
        println('.....no response ....');
        println();
        println();
    }
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
    //echo '<pre>'.print_r($result,TRUE).'</pre>';
    //soap_functions_and_data($SoapClientATT);
    //soap_functions_and_data($this->client);
    //$obj_doc = DOMDocument::load($this->wsdl);
    //println();
    //println('<b>WSDL Document:</b>');
    //print(formatXML($obj_doc->saveXML()));
} //** end diagnose()

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

function formatXML($xml) {
    $obj_doc = DOMDocument::loadXML($xml);
    $obj_doc->formatOutput = TRUE; //** we want a nice output
    //return('<pre>'.  htmlentities($obj_doc->saveXML()).'</pre>');
    return($obj_doc->saveXML());
    if (FALSE) return('<span style="font-family: monospace; font-size: 12px;">'.
           nl2br(str_replace(array(' ',"\t"),"&nbsp;",htmlentities($obj_doc->saveXML()))).
           '</span>');
}

function toArray($obj) {
    $return=array();
    if (is_array($obj)) {
        $keys=array_keys($obj);
    } elseif (is_object($obj)) {
        $keys=array_keys(get_object_vars($obj));
    } else {return $obj;}
    foreach ($keys as $key) {
        $value=$obj->$key;
        if (is_array($obj)) {
            $return[$key]=toArray($obj[$key]);
        } else {
            $return[$key]=toArray($obj->$key);
        }
    }
    return $return;
} 


function open_soapclient($app='',$wsdl='',$http_auth=array(),$refresh_wsdl_cache=TRUE) {
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
            $http_auth=array('login'=>'connectit','password'=>'1234567');
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

?>
