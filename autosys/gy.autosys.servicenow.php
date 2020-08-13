#!/usr/bin/php
<?php
require_once('../common/lib/goodyear/Tail.php');
require_once('../common/lib/goodyear/locking_functions.php');
require_once('../common/lib/goodyear/databases.php');
require_once('../common/lib/goodyear/goodyear_functions.php');
require_once('../common/lib/goodyear/servicenow_functions.php');
require_once('../common/lib/goodyear/application_environment.php');
$status_directory=str_replace('autosys','status',__DIR__);
$status_file=$status_directory.DIRECTORY_SEPARATOR.basename(__FILE__,'.php').'.position';

// Make sure we NEVER EVER run another copy of ourselves before we do anything with DB records or Web Services!
$lock_handle=open_script_file_lock(array('directory'=>$status_directory));

$debug=TRUE;
$debug_detail=FALSE;
$debug_loglines=TRUE;
date_default_timezone_set('America/New_York');
$sleeptime = 1000000;
$hostname=gethostname();
if ($hostname===FALSE) {
  println("Unable to find hostname");
  exit(1);
}
$script_start_time=microtime(TRUE);

if ($debug) print_log('Script start: '.basename(__FILE__));

$application_environment=get_application_environment();
switch ($application_environment) {

  case 'development':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.DEV/out/';
    $file='event_demon.DEV';
    $db_autosys_str='ats11d';
    $rest_endpoint='https://goodyeardev.service-now.com/api/now/table/';
    $servicenow_login='LDSNASD';
    $servicenow_password='WhatIsJobScheduling4OnDev';
  break;
  case 'test':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.TTS/out/';
    $file='event_demon.TTS';
    $db_autosys_str='ats11t';
    $rest_endpoint='https://goodyeartest.service-now.com/api/now/table/';
    $servicenow_login='LDSNAST';
    $servicenow_password='WhatIsJobScheduling4OnTest';
  break;
  case 'production':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
    if ($hostname=='akrlx323') $file='event_demon.PRD';
    if ($hostname=='akrlx324') $file='event_demon.shadow.PRD';
    $db_autosys_str='ats11p';
    $rest_endpoint='https://goodyear.service-now.com/api/now/table/';
    $servicenow_login='LDSNASP';
    $servicenow_password='WhatIsJobScheduling4OnProd';
  break;

}
$fqfn=$dir.$file;

// OPEN DB SOURCE
$db_autosys = open_db($db_autosys_str);
print_log("AutoSys DB opened ($db_autosys_str)");

// Tail the AutoSys log file
$tail = new Tail($fqfn,$status_file);

while (TRUE) {
  for ( $line=$tail->getline(); !($line===FALSE); $line=$tail->getline() ) {
    $pos=$tail->getpos();
    if ($line===FALSE) print("THIS SHOULD NEVER HAPPEN!!!\n");
    // Is this a line of interest?
    $incident_type='';
    if (strpos($line, 'STATUS: FAILURE')!==FALSE) {
      $incident_type='JOB FAILURE';
    } elseif (strpos($line, 'STATUS: TERMINATED')!==FALSE) {
      $incident_type='JOB FAILURE';
    } elseif (strpos($line, 'ALARM: MAXRUNALARM')!==FALSE) {
      $incident_type='MAXRUNALARM';
    } elseif (strpos($line, 'ALARM: RESOURCE')!==FALSE) {
      $incident_type='RESOURCE';
    } elseif (strpos($line, 'ALARM: CHASE')!==FALSE) {
      $incident_type='CHASE';
    } elseif (strpos($line, 'ALARM: MAX_RETRYS')!==FALSE) {
      $incident_type='MAX_RETRY';
    }
    if ($debug_loglines) {
      $line=str_replace("\n"," (pos:$pos)",$line);
      println($line);
      flush();
    }
    if (!empty($incident_type)) {
      $loginfo=get_loginfo($line);
      create_incident($db_autosys,$rest_endpoint,$servicenow_login,$servicenow_password,$loginfo['jobname'],$incident_type,$loginfo['datetime'],$hostname);
    }
  }
  usleep($sleeptime);
  $script_run_time=microtime(TRUE)-$script_start_time;
  $time_seconds=(integer)date('s');
  $time_hh_mm=date('H:i');
  if ($debug_detail) {
    print("script run time=$script_run_time\n");
    print("time_seconds=$time_seconds\n");
  }
    // Let's exit now, and let CRONTAB start us again
  // EXCEPT at 23:59 because we don't want to miss any events from log changeover
  if ($time_seconds>=55 and $time_seconds<59 and $time_hh_mm!='23:59') {
    // CLEANUP and EXIT NICELY
    if ($debug) print_log('Script exit: '.basename(__FILE__).', run time: '.number_format($script_run_time,1).'s');
    flush();
    close_script_file_lock($lock_handle);
    exit(0);
  }
}

// Define functions used

function get_loginfo ($line) {
  $debug=TRUE;
  $words = preg_split('/\s+/', $line);  //Split string by a regular expression
  if (empty($words[8])) {
    $loginfo['jobname']='';
  } else {
    $loginfo['jobname']=$words[8];
  }
  $log_datetime_str=$words[0].' '.$words[1];
  $log_datetime_obj=DateTime::createFromFormat('!\[m/d/Y H:i:s\]', $log_datetime_str);
  if ($log_datetime_obj===FALSE) {
    println("log_datetime_obj NOT created");
    $loginfo['datetime']=$log_datetime_str;
  } else {
    $loginfo['datetime']=$log_datetime_obj->format('Y-m-d H:i:s');
  }
  return($loginfo);
}

function create_incident ($db_autosys,$rest_endpoint,$servicenow_login,$servicenow_password,$jobname,$incident_type,$log_datetime,$autosys_server) {
  $debug=TRUE;
  if ($debug) print_log('begin function '.__FUNCTION__);
  $sql="
SELECT
  job.job_name,
  enum.str_value as job_type,
  job.description AS job_description,
  job.mach_name AS autosys_agent,
  jobsd.description AS sd_description,
  jobsd.attribute,
  jobsd.priority,
  job.n_retrys,
  job.service_desk,
  job_status.exit_code
FROM AEDBADMIN.ujo_job job
LEFT JOIN AEDBADMIN.ujo_meta_enumerations enum
  ON (
    enum.enum_name='jobtype' AND
    enum.enumeration=job.job_type AND
    LENGTH(enum.str_value)>1
    )
LEFT JOIN AEDBADMIN.ujo_service_desk jobsd
  ON (
    job.joid = jobsd.joid AND
    job.job_ver=jobsd.job_ver AND
    job.over_num=jobsd.over_num
    )
LEFT JOIN AEDBADMIN.ujo_job_status job_status
  ON (
    job.joid = job_status.joid AND
    job.job_ver = job_status.job_ver AND
    job.over_num = job_status.over_num
    )
WHERE
  job.is_active=1 AND
  job.is_currver=1 AND
  job.job_name='$jobname'
";
  $row=getrowfromdb($db_autosys,$sql);
  if($debug) print_log("AutoSys DB data=".print_r($row,TRUE));

  // DECIDE IF WE ARE SENDING A TICKET
  if ($row['job_type']=='BOX') {
    if ($debug) println("WONT create incident because job_type='BOX'");
  } elseif ( ($incident_type=='JOB FAILURE') and ($row['n_retrys']>0) ) { 
    if ($debug) println("WONT create incident because incident_type='JOB FAILURE' and n_retrys=".$row['n_retrys']);
  } elseif ( ($row['job_type']=='FW') and ($row['service_desk']==0) ) {
    if ($debug) println("WONT create incident because incident_type='FW' and service_desk=".$row['service_desk']);
  } elseif ( $row['exit_code']==199 ) {
    if ($debug) println("WONT create incident because exit_code=".$row['exit_code']);
  } else {  // We are now going to create an Incident
    if ($row['priority']==1) {
      $incident_info['impact']=1;
      $incident_info['urgency']=1;
    }
     elseif ($row['priority']==2) {
       $incident_info['impact']=2;
       $incident_info['urgency']=2;
    }
     elseif ($row['priority']==3) {
       $incident_info['impact']=3;
       $incident_info['urgency']=3;
    }
    else {
      $incident_info['impact']=3;
      $incident_info['urgency']=3;
    }


    $pos_group_eq=stripos($row['attribute'],'group="');
    if ($pos_group_eq===FALSE) {
      if ($debug) println("'group=\"' NOT found in attribute field so defaulting to 'GLOBAL_SNO_L1'");
      $incident_info['group']='GLOBAL_SNO_L1';
    } else {
      $pos_quote_1=$pos_group_eq+7;
      $pos_quote_2=strpos($row['attribute'],'"',$pos_group_eq+8);
      if ($pos_quote_2===FALSE) {
        if ($debug) println("second '\"' NOT found for 'group=\"' in attribute field so defaulting to 'GLOBAL_SNO_L1'");
        $incident_info['group']='GLOBAL_SNO_L1';
      } else {
        $incident_info['group']=substr($row['attribute'],$pos_quote_1, $pos_quote_2-$pos_quote_1);
      }
    }

    if ( (stripos($row['attribute'],'NO_ACTION')===FALSE) or ($incident_info['group']=='GLOBAL_SNO_L1') ) {
      $incident_info['state']=SN_INCIDENT_STATE_NEW;
    } else {
      $incident_info['state']=SN_INCIDENT_STATE_CLOSED;
    }

    $incident_info['jobname']=$jobname;
    $incident_info['incident_type']=$incident_type;
    $incident_info['autosys_datetime']=$log_datetime;
    $incident_info['job_description']=$row['job_description'];
    $incident_info['sd_description']=$row['sd_description'];
    $incident_info['attribute']=$row['attribute'];
    $incident_info['autosys_server']=$autosys_server;
    $incident_info['correlation_id']=$log_datetime.'|'.$jobname;  // This needs to be the Unique Incident ID for the AutoSys system
    $incident_info['caller_id']=$servicenow_login;
    if ($debug) println("WILL create incident with info=".print_r($incident_info,TRUE));   
    $json_request=format_json_create_incident($incident_info);


//REST CALL TO CREATE INCIDENT
    $rest_create_start = microtime(TRUE);
    $params = array('sysparm_fields'=>'number,sys_id');
    if ($debug) print_log("JSON Request=".PHP_EOL.json_beautify($json_request));
    $json_obj = serviceNowTableRest($rest_endpoint, $servicenow_login, $servicenow_password, $tableName='incident', $params, $requestType = 'POST', $sysID = '', $jsonInput = $json_request);
    $rest_create_response = (microtime(TRUE)-$rest_create_start);
    if ($debug) print_log("JSON Response=".PHP_EOL.json_beautify(json_encode($json_obj)));
    if ($debug) print_log('REST response time:'.number_format($rest_create_response,1).'s to Create Incident '."'$incident_info[correlation_id]'");

//NOW CLOSE IT IF AN AUTOCLOSE INCIDENT
    if($incident_info['state']==SN_INCIDENT_STATE_CLOSED) {
      $params = array('sysparm_fields'=>'number,state,sys_id');
      $sys_id=$json_obj->result->sys_id;
      $json_close_request_arr= array(
        'state'=>SN_INCIDENT_STATE_CLOSED,
      );
      $json_close_request=json_encode($json_close_request_arr); 
      if ($debug) print_log("JSON Request=".PHP_EOL.json_beautify($json_close_request));
      $rest_create_start = microtime(TRUE);
      $json_obj = serviceNowTableRest($rest_endpoint, $servicenow_login, $servicenow_password, $tableName='incident', $params, $requestType = 'PUT', $sys_id, $json_close_request);
      $rest_create_response = (microtime(TRUE)-$rest_create_start);
      if ($debug) print_log("JSON Response=".PHP_EOL.json_beautify(json_encode($json_obj)));
      if ($debug) print_log('REST response time:'.number_format($rest_create_response,1).'s to Update Incident '."'$incident_info[correlation_id]");
    }
  }

  if ($debug) print_log('end function '.__FUNCTION__);
}

function print_log($line) {
  print(date('[Y-m-d H:i:s] ').$line.PHP_EOL);
}

function format_json_create_incident($incident_info) {
// Set up all the fields needed to Create an Incident in ServiceNow
  // SET UP THE IncidentDescription
  $new_line="\r\n";
  $BriefDescription   ="AutoSys '$incident_info[incident_type]' on $incident_info[jobname]";
  $IncidentDescription="Automated AutoSys Incident: $new_line".
                       " ".$BriefDescription." $new_line".
                       "Job Description: $new_line".
                       " $incident_info[job_description] $new_line".
                       "Service Desk Description: $new_line".
                       " $incident_info[sd_description] $new_line".
                       "Service Desk Additional Information: $new_line".
                       " $incident_info[attribute] $new_line".
                       "AutoSys DateTime: $incident_info[autosys_datetime] $new_line";

  $array_request=array(
    'assignment_group'=>$incident_info['group'],
    'short_description'=>$BriefDescription,
    'description'=>$IncidentDescription,
    'impact'=>$incident_info['impact'],
    'urgency'=>$incident_info['urgency'],
    'category'=>'applications',
    'subcategory'=>'error',
    'cmdb_ci'=>'Autosys - Job Scheduling',
    'business_service'=>'',
    'correlation_id'=>$incident_info['correlation_id'], // This is the Unique ID for the Incident in ServiceNow's Remote System
    'correlation_display'=>'gy_ca_autosys',             // THis is the Unique Remote System ID
    'state'=>SN_INCIDENT_STATE_NEW,
    'caller_id'=>$incident_info['caller_id'],
    'u_preferred_contact_method_caller'=>'email',
    'u_impacted_user'=>$incident_info['caller_id'],
    'u_preferred_contact_method_impacted_user'=>'email',
    'contact_type'=>'integration',
  );
  $json=json_encode($array_request);
  if ( $json === FALSE ) {
    print('json_encode failed, tried to json_encode:'.print_r($array_request,TRUE));
    exit(69);
  } else {
    return($json);
  }
}

 
function serviceNowTableRest($rest_endpoint, $login, $password, $tableName, $params, $requestType = 'GET', $sysID = '', $jsonInput = '') {
  $debug_url=TRUE;
  $debug_http_response_code=TRUE;
  $debug_jsons=FALSE;
  $debug_curl_response=FALSE;
  $debug_curl_verbose=FALSE;
  //Validate RequestType
  if (!in_array($requestType, (array('POST', 'PUT', 'DELETE', 'GET', 'PATCH')))) {
    throw new ErrorException("requestType must be one of: 'POST','DELETE','GET','PATCH'");
  }
  if (in_array($requestType, (array('PUT', 'DELETE', 'PATCH'))) && empty($sysID)) {
    throw new ErrorException("sysID is required for 'PUT','DELETE','PATCH' requestType");
  }

  // If sysID is set, need to prefix with '/' so it can be appended to URL after tableName.
  if (!empty($sysID)) {
    $sysID = '/' . $sysID;
  }

  $curlHandle = curl_init();
  curl_setopt($curlHandle, CURLOPT_CUSTOMREQUEST, $requestType);
  curl_setopt($curlHandle, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
  curl_setopt($curlHandle, CURLOPT_USERPWD, "$login:$password");
  curl_setopt($curlHandle, CURLOPT_VERBOSE, $debug_curl_verbose);
  curl_setopt($curlHandle, CURLOPT_HEADER, false);
  curl_setopt($curlHandle, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($curlHandle, CURLOPT_SSL_VERIFYHOST, false);
  curl_setopt($curlHandle, CURLOPT_RETURNTRANSFER, true);

  if (!empty($jsonInput)) {
    curl_setopt($curlHandle, CURLOPT_HTTPHEADER, array("Content-Type: application/json"));
    curl_setopt($curlHandle, CURLOPT_POSTFIELDS, $jsonInput);
  }
  $paramList = array();
  foreach ($params as $key => $value) {
    $paramList[] = $key . '=' . $value;
  }
  $url = $rest_endpoint . $tableName . $sysID . '?' . implode('&', $paramList);
  if ($debug_url) print("URL:$url with REST request type:$requestType".PHP_EOL);

  curl_setopt($curlHandle, CURLOPT_URL, $url);

  if ($debug_jsons) {
    if (!empty($jsonInput)) {
      var_dump($jsonInput);
    }
  }
  $response = curl_exec($curlHandle);
  if ($debug_curl_response) {
    var_dump($response);
  }
  $json = json_decode($response);
  if ($debug_jsons) {
    var_dump($json);
  }
  if ($json != "" && property_exists($json, 'error')) {
    throw new ErrorException("SN JSON Error: {$json->error->detail}");
  }

  /* Possible REST API HTTP response codes.
    200	Success	Success with response body .
    201	Created	Success with response body .
    204	Success	Success with no response body .
    400	Bad Request	The request URI does not match the APIs in the system, or the operation failed for unknown reasons . Invalid headers can also cause this error .
    401	Unauthorized	The user is not authorized to use the API .
    403	Forbidden	The requested operation is not permitted for the user . This error can also be caused by ACL failures, or business rule or data policy constraints .
    404	Not found	The requested resource was not found . This can be caused by an ACL constraint or if the resource does not exist .
    405	Method not allowed	The HTTP action is not allowed for the requested REST API, or it is not supported by any API .
    406	Not acceptable	The endpoint does not support the response format specified in the request Accept header .
    415	Unsupported media type	The endpoint does not support the format of the request body .
  */
  $httpcode = curl_getinfo($curlHandle, CURLINFO_HTTP_CODE);
  curl_close($curlHandle);
  if ($debug_http_response_code) print("HTTP response code:$httpcode".PHP_EOL);
  if (!($httpcode == 200 OR $httpcode == 201 OR $httpcode == 204)) {
    throw new ErrorException("Curl request for '$requestType' failed with REST HTTP Code: $httpcode", $httpcode);
  }
  return ($json);
}


function json_beautify( $json, $indent='  ' ) {
  $result = '';
  $level = 0;
  $in_quotes = false;
  $in_escape = false;
  $ends_line_level = NULL;
  $json_length = strlen( $json );

  for( $i = 0; $i < $json_length; $i++ ) {
    $char = $json[$i];
    $new_line_level = NULL;
    $post = '';
    if( $ends_line_level !== NULL ) {
      $new_line_level = $ends_line_level;
      $ends_line_level = NULL;
    }
    if ( $in_escape ) {
      $in_escape = false;
    } else if( $char === '"' ) {
      $in_quotes = !$in_quotes;
    } else if( ! $in_quotes ) {
      switch( $char ) {
        case '}': case ']':
          $level--;
          $ends_line_level = NULL;
          $new_line_level = $level;
          break;

        case '{': case '[':
          $level++;
        case ',':
          $ends_line_level = $level;
          break;

        case ':':
          $post = " ";
          break;

        case " ": case "\t": case "\n": case "\r":
          $char = '';
          $ends_line_level = $new_line_level;
          $new_line_level = NULL;
          break;
      }
    } else if ( $char === '\\' ) {
      $in_escape = true;
    }
    if( $new_line_level !== NULL ) {
      $result .= "\n".str_repeat( $indent, $new_line_level );
    }
    $result .= $char.$post;
  }
  return $result;
}
