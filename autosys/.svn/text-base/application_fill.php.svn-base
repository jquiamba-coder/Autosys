#!/usr/bin/php
<?php
$debug=FALSE;
$debug=TRUE;

$jil_file='/home/ld874p1/jil1.txt';
$global_variable='ac2_up'; // this should be in the condition: field
$application_name='ac2';   //application name to add to the application: field


$handle = @fopen($jil_file,'r');
while (!feof($handle)) {
  $box=get_box($handle);
  print_r($box);
}
exit;

while (!feof($handle)) {
  $line=trim(getline($handle));
  if (string_contains($line,"job_type:")) {
    unset($job);
    $words=explode(' ',$line);
    if (FALSE) {
      print_r($words);
    }
    $job_type=$words[5];
    $job['job_type:']=$job_type;
    if ($job_type=='BOX') {
      $job['box_name:']=$words[1];
    } else {
      $job['job_name:']=$words[1];
    }
    while (!feof($handle) and $line!='') {
      $line=trim(getline($handle));
      $words=explode(' ',$line,$limit=2);
      if ( !empty($words[0]) and !empty($words[1]) ) {
        $parameter=$words[0];
        $value=$words[1];
        $job[$parameter]=$value;
      }
    }
    if ($job_type=='BOX') {
      if (isset($box)) print_r($box);
      unset($box);
      $box=$job;
    } else {
      $box['jobs'][]=$job;
    }
    //print_r($job);
  }
}
if (isset($box)) print_r($box);
exit;


function get_box($handle) {

  println('entering ' .__FUNCTION__.'()');
  $debug=FALSE;
  $debug=TRUE;
  while (!feof($handle)) {
    $raw_line=getline($handle);
    $line=trim($raw_line);
    if (string_contains($line,"job_type:")) {
      unset($job);
      $words=explode(' ',$line);
      if ($debug_job_type=FALSE) {
        print_r($words);
      }
      $job_type=$words[5];  // job_type is the 5th word on the line with 'job_type:' on it
      $job['job_type:']=$job_type;
      if ($job_type=='BOX') {
	$raw_line_length=strlen($raw_line);
	$offset=-$raw_line_length;
        $job['box_name:']=$words[1];
      } else {
        $job['job_name:']=$words[1];
      }
      while (!feof($handle) and $line!='') {
	$raw_line=getline($handle);
        $line=trim($raw_line);
        $words=explode(' ',$line,$limit=2);
        if ( !empty($words[0]) and !empty($words[1]) ) {
          $parameter=$words[0];
          $value=$words[1];
          $job[$parameter]=$value;
        }
      }
      if ($job_type=='BOX') {
	$raw_line_length=strlen($raw_line);
	$offset=-$raw_line_length;
	fseek($handle,$offset,$whence=SEEK_CUR); // pretend we didn't read that line!!!
        if (isset($box)) {
	  if ($debug) print_r($box);
	  return($box);
	}
        unset($box);
        $box=$job;
      } else {
        $box['jobs'][]=$job;
      }
      //print_r($job);
    }
  }
  if (isset($box)) {
    if ($debug) print_r($box);
    return($box);
  }
}


function string_contains($haystack,$needle) {
  if(strpos($haystack,$needle) !== false) {
    return(TRUE);
  } else {
    return(FALSE);
  }
}

function getline($handle) {
  $debug=FALSE;
  $debug=TRUE;
  if ($debug) println("begin file position=".ftell($handle));
  while (!feof($handle)) {
    $line=stream_get_line($handle,4096,"\n");
    if ($debug) {
      println("text line>>>$line<<<");
      println("end file position=".ftell($handle));
      println();
    }
    return($line);
  }
}

function println($line='') {
  print($line.PHP_EOL);
}
