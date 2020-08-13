#!/usr/bin/php
<?php
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
   if ($how=='G') $email='AHQ '.str_replace('_',' ',$who);


   $job_prefixes[]=$job_prefix;
   $jobs[$job_prefix]['who']=$who;
   $jobs[$job_prefix]['how']=$how;
   $jobs[$job_prefix]['assignment']=$assignment;
   $jobs[$job_prefix]['priority']=$priority;
   $jobs[$job_prefix]['email']=$email;
}

print("Job prefixes:\n");
print_r($job_prefixes);

usort($job_prefixes, 'sortByLen');

print("Sorted Job prefixes:\n");
print_r($job_prefixes);

print("now the cleansed, sorted config:\n");
foreach ($job_prefixes as $job_prefix) {
  print("$job_prefix=");
  print_r($jobs[$job_prefix]);
}


// functions

function sortByLen($a, $b) {
  if (strlen($a) == strlen($b)) {
    return 0;
  } else {
    return( (strlen($a)>strlen($b))?-1:1 );
  }
}

function cleanse_config(&$config_lines) {
  $config_begin=FALSE;
  $config_end=FALSE;
  $is_config=FALSE;
  foreach($config_lines as $line_num => $config_line) {
    if(substr($config_line,0,7)=='BEGIN_W') {
      $config_begin=TRUE;
    } else {
      $config_begin=FALSE;
    }
    if(substr($config_line,0,7)=='END_WAT') {
      $config_end=TRUE;
    } else {
      $config_end=FALSE;
    }
    if(substr($config_line,0,1)=='#') {
      $is_comment=TRUE;
    } else {
      $is_comment=FALSE;
    }
    if ($config_begin) $is_config=TRUE;
    if ($config_end) $is_config=FALSE;
   
    $config_lines[$line_num]=trim($config_line);
    if ($is_comment) $config_lines[$line_num].=':IS_COMMENT:';
    if ($config_begin) $config_lines[$line_num].=':CONFIG_BEGIN:';
    if ($config_end) $config_lines[$line_num].=':CONFIG_END:';
    #if ($is_config) $config_lines[$line_num].=':IS_CONFIG:';

    $delete=FALSE;
    if (!$is_config) $delete=TRUE;
    if ($is_comment) $delete=TRUE;
    if ($config_begin) $delete=TRUE;

    if ($delete) $config_lines[$line_num].=':DELETE:';
   
    if ($delete) unset($config_lines[$line_num]);
  } 
}


exit;

