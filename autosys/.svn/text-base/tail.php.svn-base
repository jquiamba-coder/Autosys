#!/usr/bin/php
<?php

$dir='/opt/CA/WorkloadAutomationAE/autouser.PRD/out/';
$file='event_demon.shadow.PRD';
$fqfn=$dir.$file;
$lastpos = 0;
while (true) {
  usleep(300000); //0.3 s
  clearstatcache(false, $fqfn);
  $len = filesize($fqfn);
  if ($len < $lastpos) {
    //file deleted or reset
    $lastpos = $len;
  } elseif ($len > $lastpos) {
    $f = fopen($fqfn, "rb");
    if ($f === false)
      die();
    fseek($f, $lastpos);
    while (!feof($f)) {
      //$buffer = fread($f, 4096);
      $line = fgets($f,4096);
      //echo $buffer;
      echo $line;
      flush();
    }
    $lastpos = ftell($f);
    fclose($f);
  }
}

