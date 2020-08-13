#!/usr/bin/php
<?php
set_include_path(get_include_path().PATH_SEPARATOR.'../common/lib/goodyear');
include_once 'goodyear_functions.php';
include_once 'autosys_functions.php';
$db_name='ats11'.getenv('AUTOSYS_DB_SUFFIX');

$today_string=date('Y-m-d');
$jilfile=str_replace('.php',"_$today_string.jil",__FILE__);
$jilfile=str_replace('/autosys/','/reports/',$jilfile);
println("Opening '$jilfile' for writing");
$jilfile_handle=fopen($jilfile,'w');

$config_file="/opt/CA/WorkloadAutomationAE/autouser.PRD/out/event_monitor.PRD.cfg";
$config_lines=file($config_file);

cleanse_config($config_lines);

print("Cleansed config file:\n");
print_r($config_lines);

$jobs=array();
$job_prefixes=array();
foreach($config_lines as $line_num => $config_line) {
   $fields=explode('|',$config_line);
   $job_prefix=trim($fields[0]);
   if (count($fields)!=5) {
     print("job_prefix:$job_prefix has something wrong, there are not 5 fields\n");
     $fields[]='***SOMETHING IS WRONG ***';
   }

   $who=trim($fields[1]);
   $how=trim($fields[2]);
   $assignment=trim($fields[3]);
   $priority=trim($fields[4]);

   if ($how=='E') $email=$who;
   if ($how=='G') $email=strtolower('ahq.'.str_replace('_','.',$who)).'@goodyear.com';
   if ($priority=='2/2') {
     $simple_priority=2;
   } else { 
     $simple_priority=3;
   }


   $job_prefixes[]=$job_prefix;
   $jobs[$job_prefix]['who']=$who;
   $jobs[$job_prefix]['how']=$how;
   $jobs[$job_prefix]['assignment']=$assignment;
   $jobs[$job_prefix]['priority']=$priority;
   $jobs[$job_prefix]['simple_priority']=$simple_priority;
   $jobs[$job_prefix]['email']=$email;
}

print("Job prefixes:\n");
//print_r($job_prefixes);

usort($job_prefixes, 'sortByLen');

print("Sorted Job prefixes:\n");
print_r($job_prefixes);


print("now the cleansed, sorted config:\n");
foreach ($job_prefixes as $job_prefix) {
  print("$job_prefix=");
  print_r($jobs[$job_prefix]);
}

$db=open_db($db_name);
$job_type_box=JOB_TYPE_BOX;
$sql="
SELECT DISTINCT job_name FROM aedbadmin.ujo_job
WHERE is_active=1
AND is_currver=1
AND job_type!=$job_type_box
ORDER BY job_name";
$job_names=getcolfromdb($db,$sql);

$count=count($job_names);
print("$count jobnames returned\n");

foreach($job_names as $job_name) {
  print("$job_name\n");
}

foreach($job_names as $job_name) {
  $job_prefix=lookup_config($job_name,$job_prefixes);
  println("job_prefix='$job_prefix'");
  if ($job_prefix!==FALSE) {
     fwrite($jilfile_handle,
           "update_job:$job_name".
           ' svcdesk_attr:"'.'group="'.$jobs[$job_prefix]['assignment'].'"'.'"'.
           ' svcdesk_pri:'.$jobs[$job_prefix]['simple_priority'].
	   "\n");
  }
}

fclose($jilfile_handle);
exit;


function lookup_config(&$job_name,&$job_prefixes) {
  foreach($job_prefixes as $job_prefix) {
    if (fnmatch($job_prefix,$job_name)) {
      return($job_prefix);
    }
  }
  return(FALSE);
}

