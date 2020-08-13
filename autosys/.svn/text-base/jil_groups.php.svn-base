#!/usr/bin/php
<?php
set_include_path(get_include_path().PATH_SEPARATOR.'../common/lib/goodyear');
include_once 'goodyear_functions.php';
include_once 'databases.php';
include_once 'autosys_functions.php';
$db_name='ats11'.getenv('AUTOSYS_DB_SUFFIX');

$today_string=date('Y-m-d');
$jilfile=str_replace('.php',"_$today_string.jil",__FILE__);
$jilfile=str_replace('/autosys/','/reports/',$jilfile);
println("Opening '$jilfile' for writing");
$jilfile_handle=fopen($jilfile,'w');

$db=open_db($db_name);
$job_type_box=JOB_TYPE_BOX;
$sql="
SELECT DISTINCT job_name FROM aedbadmin.ujo_job
WHERE is_active=1
AND is_currver=1
AND job_type!=$job_type_box
ORDER BY job_name";
$jobnames=getcolfromdb($db,$sql);

$count=count($jobnames);
print("$count jobnames returned\n");

foreach($jobnames as $key => $jobname) {

  $group_old=lookup_group($db,$jobname);
  $jobs[$jobname]['group_old']=$group_old;

  $jobname_prefix=substr($jobname,0,3);
  $jobs[$jobname]['jobname_prefix']=$jobname_prefix;

  if ($group_old=='') {
    switch($jobname_prefix) {
  
    case 'CAP':
    case 'CLA':
    case 'CNA':
    case 'COR':
    case 'EDW':
    case 'EUR':
    case 'GBI':
    case 'GPO':
    case 'LAT':
      $group_new='NAUSAK_EDW_Autosys_NoAction';  
    break;

    case 'cjp':
    case 'DAV':
    case 'TST':
      $group_new='NAUSAK_Autosys';
    break;
  
    default:
      $group_new='NAUSAK_NAT_Autosys_NoAction';
    break;

    }
    $jobs[$jobname]['group_new']=$group_new;
  } else {
    //$group_new=$group_old;
    unset($jobs[$jobname]);
  }
  if ($group_old=='') {
    print("record #$key($jobname)=".print_r($jobs[$jobname],TRUE));
  } else {
    println("record #$key($jobname), group_old='$group_old'");
  }
}

print_r($jobs);

foreach($jobs as $jobname => $job) {
  fwrite($jilfile_handle,
    "update_job:$jobname".
    ' svcdesk_attr:"'.'group="'.$job['group_new'].'"'.'"'.
    "\n");
}

fclose($jilfile_handle);
exit;


function lookup_group($db,$jobname) {
  $debug=FALSE;
  $sql="
SELECT
  job.job_name,
  jobsd.attribute
FROM AEDBADMIN.ujo_job job
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
  $row=getrowfromdb($db,$sql);
  if($debug) println("AutoSys DB data=".print_r($row,TRUE));

  $pos_group_eq=stripos($row['attribute'],'group="');
  if ($pos_group_eq===FALSE) {
    $group='';
  } else {
    $pos_quote_1=$pos_group_eq+7;
    $pos_quote_2=strpos($row['attribute'],'"',$pos_group_eq+8);
    if ($pos_quote_2===FALSE) {
      $group='';
    } else {
      $group=substr($row['attribute'],$pos_quote_1, $pos_quote_2-$pos_quote_1);
    }
  }
  return($group);
}
