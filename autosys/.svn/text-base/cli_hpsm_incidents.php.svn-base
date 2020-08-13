#!/usr/bin/php
<?php
require_once('../common/lib/goodyear/databases.php');
require_once('../common/lib/goodyear/goodyear_functions.php');

$debug=TRUE;
$debug=FALSE;
date_default_timezone_set('America/New_York');
$hostname=gethostname();
if ($hostname===FALSE) {
  println("Unable to find hostname");
  exit(1);
}

switch ($hostname) {

  case 'akrlx271':
    //ini_set('default_socket_timeout', 5);
    $dir='/opt/CA/WorkloadAutomationAE/autouser.DEV/out/';
    $file='event_demon.DEV';
    $db_autosys_str='ats11d';
    $db_hpsm_str='svc01d_ro';
    $wsdl_im='http://svcmgrd.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx322':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.TTS/out/';
    $file='event_demon.TTS';
    $db_autosys_str='ats11t';
    $db_hpsm_str='svc01t_ro';
    $wsdl_im='http://svcmgrt.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    //$wsdl_im='http://akrlx274.akr.goodyear.com:13087/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx323':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
    $file='event_demon.PRD';
    $db_autosys_str='ats11p';
    $db_hpsm_str='svc01p_ro';
    $wsdl_im='http://svcmgr.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;
  case 'akrlx324':
    $dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
    $file='event_demon.shadow.PRD';
    $db_autosys_str='ats11p';
    $db_hpsm_str='svc01p_ro';
    $wsdl_im='http://svcmgr.akr.goodyear.com:13080/sc62server/PWS/IncidentManagementAutosys.wsdl';
    $http_auth=array('login'=>'autosys','password'=>'caautosys');
  break;

}
$fqfn=$dir.$file;

// OPEN DB SOURCE
$db_autosys = open_db($db_autosys_str);

// NOT USED - THIS IS FOR DOCUMENTATION
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
  job.job_name=''
";


$sql="
SELECT AS_DATETIME,AS_JOBNAME, HPSM_INCIDENT_ID
 FROM AEDBADMIN.view_hpsm_incidents
";

  $rows=get_records($db_autosys,$sql);
  if($debug) println("AutoSys DB data=".print_r($rows,TRUE));
  foreach ($rows as $row) {
    println($row['as_datetime'].', '.$row['as_jobname'].', '.$row['hpsm_incident_id']);
  }
 exit(0);
?>
