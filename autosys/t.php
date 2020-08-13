#!/usr/bin/php
<?php
require_once('../common/lib/goodyear/Tail.php');
require_once('../common/lib/goodyear/locking_functions.php');
require_once('../common/lib/goodyear/databases.php');
require_once('../common/lib/goodyear/goodyear_functions.php');
require_once('../common/lib/goodyear/web_functions.php');
$status_file='../status/monitor_demon_log.status';

// Make sure we NEVER EVER run another copy of ourselves before we do anything with DB records or Web Services!
$lock_handle=open_script_file_lock();

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

switch ($hostname) {

  case 'akrlx271':
    //ini_set('default_socket_timeout', 5);
    $dir='/opt/CA/WorkloadAutomationAE/autouser.DEV/out/';
    $file='event_demon.DEV';
    $db_autosys_str='ats11d';
    $wsdl_im='http://svcmgrd.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx322':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.TTS/out/';
    $file='event_demon.TTS';
    $db_autosys_str='ats11t';
    $wsdl_im='http://svcmgrt.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    //$wsdl_im='http://akrlx274.akr.goodyear.com:13087/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx323':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
    $file='event_demon.PRD';
    $db_autosys_str='ats11p';
    $wsdl_im='http://svcmgr.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx324':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
    $file='event_demon.shadow.PRD';
    $db_autosys_str='ats11p';
    $wsdl_im='http://svcmgr.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;

}
$fqfn=$dir.$file;

$wsdl_im='https://dev38340.service-now.com/AutosysIncident.do?WSDL';
$http_auth=array('login'=>'admin','password'=>'Doj20clmm$');

// OPEN DB SOURCE
$db_autosys = open_db($db_autosys_str);
print_log("AutoSys DB opened ($db_autosys_str)");

//OPEN the WSDL SERVICES
$soapclient=open_soapclient('sm',$wsdl_im,$http_auth,$refresh_wsdl_cache=TRUE);
print_log("HPSM WSDL Service opened ($wsdl_im)");

$array_request=format_create_incident($incident_info);


$xml_create_start = microtime(true);
try {
  $result=$soapclient->insert($array_request);
  $is_xml_response=TRUE;
} catch (SoapFault $e) {
  $is_xml_response=FALSE;
  println("No XML response from Service Manager");
  //var_dump($e);
  println("Specific SoapFault is '".$e->getMessage()."' in file '".$e->getFile()."' on line ".$e->getLine().", faultcode='$e->faultcode', faultstring='$e->faultstring'");
}
$xml_create_response = (microtime(true)-$xml_create_start);
println('xml_response_time: '.number_format($xml_create_response,1).'s to CreateIncident '.$gyhpovid);
diagnose($soapclient);

exit;

// OPEN DB SOURCE
$db_autosys = open_db($db_autosys_str);
print_log("AutoSys DB opened ($db_autosys_str)");

$db_hpsm = open_db($db_hpsm_str);
print_log("HPSM DB opened ($db_hpsm_str)");

//OPEN the WSDL SERVICES
$soapclient_sm_im=open_soapclient('sm',$wsdl_im,$http_auth,$refresh_wsdl_cache=TRUE);
print_log("HPSM WSDL Service opened ($wsdl_im)");

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
      create_incident($db_autosys,$db_hpsm,$soapclient_sm_im,$loginfo['jobname'],$incident_type,$loginfo['datetime'],$hostname);
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
    close_script_file_lock($lock_handle);
    if ($debug) print_log('Script exit: '.basename(__FILE__).', run time: '.number_format($script_run_time,1).'s');
    exit(0);
  }
}

function get_loginfo ($line) {
  $words = preg_split('/\s+/', $line);
  $loginfo['jobname']=$words[8];
  $loginfo['datetime']=$words[0].' '.$words[1];
  return($loginfo);
}

function create_incident ($db_autosys,$db_hpsm,$soapclient,$jobname,$incident_type,$log_datetime,$autosys_server) {
  $debug=TRUE;
  if ($debug) println('begin function '.__FUNCTION__);
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
  job.service_desk
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
WHERE
  job.is_active=1 AND
  job.is_currver=1 AND
  job.job_name='$jobname'
";
  $row=getrowfromdb($db_autosys,$sql);
  if($debug) println("AutoSys DB data=".print_r($row,TRUE));

  // DECIDE IF WE ARE SENDING A TICKET
  if ($row['job_type']=='BOX') {
    if ($debug) println("WONT create incident because job_type='BOX'");
  } elseif ( ($incident_type=='JOB FAILURE') and ($row['n_retrys']>0) ) { 
    if ($debug) println("WONT create incident because incident_type='JOB FAILURE' and n_retrys=".$row['n_retrys']);
  } elseif ( ($row['job_type']=='FW') and ($row['service_desk']==0) ) {
    if ($debug) println("WONT create incident because incident_type='FW' and service_desk=".$row['service_desk']);
  } else {
    if ($row['priority']==2) {
      $incident_info['priority']=2;
    } else {
      $incident_info['priority']=3;
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
      $incident_info['auto_close']=FALSE;
    } else {
      $incident_info['auto_close']=TRUE;
    }

    $incident_info['jobname']=$jobname;
    $incident_info['incident_type']=$incident_type;
    $incident_info['autosys_datetime']=$log_datetime;
    $incident_info['job_description']=$row['job_description'];
    $incident_info['sd_description']=$row['sd_description'];
    $incident_info['attribute']=$row['attribute'];
    $incident_info['autosys_server']=$autosys_server;
    $gyhpovid=$incident_info['autosys_datetime'].$incident_info['jobname'];    // NEED to check if this SM Incident Record was created in the HP SM DB
    if ($debug) println("WILL create incident with info=".print_r($incident_info,TRUE));   
    $array_request=format_create_incident($incident_info);
    $is_xml_response=FALSE;          // Boolean flag - default it FALSE
    $xml_create_start = microtime(true);
    try {
      $result=$soapclient->CreateIncidentAutosys($array_request);
      $is_xml_response=TRUE;
    } catch (SoapFault $e) { 
      $is_xml_response=FALSE;
      println("No XML response from Service Manager");
      //var_dump($e);
      println("Specific SoapFault is '".$e->getMessage()."' in file '".$e->getFile()."' on line ".$e->getLine().", faultcode='$e->faultcode', faultstring='$e->faultstring'"); 
      //NEED to check if this SM Incident Record was created in the HP SM DB
      $sql="select min('NUMBER') as incident from smora.probsummarym1 t where t.opened_by = 'autosys' and open_time>sysdate-1 and t.gy_hpov_id='$gyhpovid'";
      println("Making SQL call to HP SM DB, sql=$sql");
      $incident_id=getonefromdb($db_hpsm,$sql);
      if (substr($incident_id,0,2)=='IM') {
        $sm_record_created=TRUE;
        println("Found HP SM incident_id=$incident_id for gyhpovid=$gyhpovid");
      } else {
        $sm_record_created=FALSE;
        println("No HP SM incident_id found for gyhpovid=$gyhpovid");
     }
    } catch (Exception $e) {
      println("Specific Exception is '".$e->getMessage()."' in file '".$e->getFile()."' on line ".$e->getLine().", faultcode='$e->faultcode', faultstring='$e->faultstring'"); 
    }
    $xml_create_response = (microtime(true)-$xml_create_start);
    println('xml_response_time: '.number_format($xml_create_response,1).'s to CreateIncident '.$gyhpovid);
    diagnose($soapclient);

    if ($is_xml_response) {
    // CREATE DOM Object & use its methods to parse the returned XML for the return code & anything else we need
      $obj_dom = new DOMDocument();   
      $obj_dom->loadXML($soapclient->__getLastResponse());
      $nodes=$obj_dom->getElementsByTagName('CreateIncidentAutosysResponse');
      $return_message=$nodes->item(0)->getAttribute("message");
      $return_code=   $nodes->item(0)->getAttribute("returnCode");
      println("XML Response contains return_message='$return_message' and return_code='$return_code'");
      // MAKE THE DECISION HERE: Was the SM Incident record created?
      if ($return_code==0) {  
        $sm_record_created=TRUE;
	// Get the other useful information
        //$gyhpovid   =$obj_dom->getElementsByTagName('GYHPOVID')->item(0)->nodeValue;
        $incident_id=$obj_dom->getElementsByTagName('IncidentID')->item(0)->nodeValue;
        $incident_info['group_returned']=$obj_dom->getElementsByTagName('PrimaryAssignmentGroup')->item(0)->nodeValue;
      } else {
        $sm_record_created=FALSE;
      }
    }

   
    if (FALSE) { // Leaving the AUTO CLOSE to HP Service Manager.
    //if ($incident_info['auto_close']) {
      if ($incident_info['group_returned']!=$incident_info['group']) {
        $incident_info['auto_close']=FALSE;
        if ($debug) println("'NO_ACTION' ignored because given group '$incident_info[group]' does NOT match returned group '$incident_info[group_returned]'");
      }
      if (!empty($incident_id)) {
        $incident_info['incident_id']=$incident_id;
        $incident_info['close_reason']="'NO_ACTION' was found in Service Desk Additional Information field";
        $array_request=format_close_incident($incident_info);
        $xml_close_start = microtime(true);
        try {
          $result_close=$soapclient->CloseIncidentAutosys($array_request);
        } catch (SoapFault $e) {
          println("Specific SoapFault message is '".$e->getMessage()."' in file '".$e->getFile()."' on line ".$e->getLine().", faultcode='$e->faultcode', faultstring='$e->faultstring'"); 
        }
        $xml_close_response = (microtime(true)-$xml_close_start);
        println('xml_response_time: '.number_format($xml_close_response,1).'s to CloseIncident '.$gyhpovid);
        diagnose($soapclient);
      }
    }
  }
  if ($debug) println('end function '.__FUNCTION__);
}

function print_log($line) {
  println(date('[Y-m-d H:i:s] ').$line);
}

function format_create_incident($incident_info) {
// Build the Nested Associative Array corresponding to the Nested XML Request
// SET UP THE IncidentDescription
$BriefDescription   ="AutoSys '$incident_info[incident_type]' on $incident_info[jobname]";
$IncidentDescription="Automated AutoSys Incident: \n". 
                     " ".$BriefDescription." \n".
		     "Job Description: \n".
		     " $incident_info[job_description] \n".
		     "Service Desk Description: \n".
		     " $incident_info[sd_description] \n".
		     "Service Desk Additional Information: \n".
		     " $incident_info[attribute] \n".
		     "AutoSys DateTime: $incident_info[autosys_datetime] \n";

// Build the Nested Associative Array corresponding to the Nested XML Request
$array_request=array(
  'model'=> array(
    'keys'=>array(
      'IncidentID'=>'',
      'query'=>'',
    ),
    'instance'=> array(
      'PrimaryAssignmentGroup'=>$incident_info['group'],
      'BriefDescription'=>$BriefDescription,
      'AffectedItem'=>$incident_info['autosys_server'],
      'IncidentDescription'=>array(
        'IncidentDescription'=>$IncidentDescription,
      ),
      'InitialImpact'=>$incident_info['priority'],
      'Severity'=>$incident_info['priority'],
      'Service'=>'All Base Services',
      'Contact'=>'AUTOSYS',
      'Category'=>'incident',
      'Subcategory'=>'failure',
      'ProductType'=>'error message',
      'SiteCategory'=>'B',
      'OVOapplication'=>'AutoSys',
      'OVOobject'=>$incident_info['jobname'],
      'GYSystem'=>'GLOBAL-Software', //'GYSystem'=>'NA-Software',
      'GYComponent'=>'AutoSys',
      'GYItem'=>'Job Failure',
      'GYModule'=>'n/a',
      'GYRegion'=>'NA',
      'GYHPOVID'=>$incident_info['autosys_datetime'].$incident_info['jobname'],
      'GYHPOVRegion'=>'NA',
      'GYAutoClose'=>$incident_info['auto_close'],
    ),
  ),
 'attachmentInfo'=> FALSE,
 'attachmentData'=> FALSE,
 'ignoreEmptyElements'=> TRUE,
);
$array_request=array(
  'correlation_id'=>'my autosys event id',
  'cmdb_ci'=>'akrlx322',
  'impact'=>3,
  'urgency'=>3,
  'state'=>1,
  'correlation_display'=>'ca_autosys',
  'short_description'=>'short desc',
  'category'=>'Some category',
  'subcategory'=>'Some subcategory',
  'description'=>'description',
  'assignment_group'=>'my group',
  'business_service'=>'some business services',
);
$array_request=array(
  'correlation_id'=>'my autosys event id',
  'cmdb_ci'=>'akrlx322',
  'impact'=>3,
  'urgency'=>3,
  'state'=>7,
  'correlation_display'=>'ca_autosys',
  'short_description'=>'short desc',
  'description'=>'description they really do not care about this !!!!',
  'category'=>'Some category',
  'subcategory'=>'Some subcategory',
  'assignment_group'=>'my group',
  'business_service'=>'some business services',
);

return($array_request);
}

function format_close_incident($incident_info) {
$array_request=array(
  'model'=> array(
    'keys'=>array(
      'IncidentID'=>$incident_info['incident_id'],
      'query'=>'',
    ),
    'instance'=> array(
      'Resolution'=>array(
        'Resolution'=>$incident_info['close_reason'],
      ),
      'JournalUpdates'=>array(
        'JournalUpdates'=>$incident_info['close_reason'],
      ),
    ),
  ),
'attachmentInfo'=> FALSE,
'attachmentData'=> FALSE,
'ignoreEmptyElements'=> TRUE,
);
return($array_request);
}
