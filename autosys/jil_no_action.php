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

$debug=TRUE;
$db=open_db($db_name);
$job_type_box=JOB_TYPE_BOX;
$stdin=fopen('php://stdin','r');

while($line=fgets($stdin)) {
  $jobname=trim($line);
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
  job.job_type!=$job_type_box AND
  job.job_name='$jobname'
";
  $row=getrowfromdb($db,$sql);
  if($debug) {
    if(count($row)==0) {
      println("'$jobname' is NOT a valid JOB");
    } else {
      println("AutoSys DB data=".print_r($row,TRUE));
      $group=get_group($row['attribute']);
      $auto_close=auto_close($row['attribute']);
      fwrite($jilfile_handle,
        "update_job:$jobname".
        ' svcdesk_attr:"'.'group="'.$group.'"'.'"'.
        ' NO_ACTION'.
        "\n");
    }
  }
}

fclose($stdin);
fclose($jilfile_handle);
exit;

function auto_close($string) {
  if (stripos($string,'NO_ACTION')===FALSE) {
    return(FALSE);
  } else {
    return(TRUE);
  }
}

function get_group($string) {
  $pos_group_eq=stripos($string,'group="');
  if ($pos_group_eq===FALSE) {
    $group='';
  } else {
    $pos_quote_1=$pos_group_eq+7;
    $pos_quote_2=strpos($string,'"',$pos_group_eq+8);
    if ($pos_quote_2===FALSE) {
      $group='';
    } else {
      $group=substr($string,$pos_quote_1, $pos_quote_2-$pos_quote_1);
    }
  }
  return($group);
}

