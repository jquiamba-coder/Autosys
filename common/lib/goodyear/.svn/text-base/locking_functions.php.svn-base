<?php

function open_script_file_lock($options=array()) {
  $debug=TRUE;
  $debug=FALSE;
  if (empty($options['directory'])) {
    $file_lock_name=substr($_SERVER['SCRIPT_FILENAME'],0,strrpos($_SERVER['SCRIPT_FILENAME'],'.')).'.lock';
  } else {
    $file_lock_name=$options['directory'].DIRECTORY_SEPARATOR.basename($_SERVER['SCRIPT_FILENAME'],'.php').'.lock';
  }
  $file_lock_handle=fopen($file_lock_name,'w');
  if ($file_lock_handle==FALSE) {
    if ($debug) print("Can not open lock file: '$file_lock_name'\n");
    exit(10);
  }
  if ($debug) print("Opened lock file: '$file_lock_name'\n");
  $chmod=chmod($file_lock_name,0666);  // So everyone can read and write this file
  if($debug) {
    if ($chmod) {
      if ($debug) print("Successfully chmod to 0666\n");
    } else {
      if ($debug) print("Failed to chmod to 0666\n");
    }
  }

  $locked=flock($file_lock_handle,LOCK_EX | LOCK_NB);
  if (!$locked) {
    if ($debug) print("Can not get exclusive lock\n");
    exit(11);
  } else {
    if ($debug) print("Obtained exclusive lock\n");
  }
  return($file_lock_handle);
}

function close_script_file_lock($file_lock_handle) {
  $debug=FALSE;
  flock($file_lock_handle,LOCK_UN);
  fclose($file_lock_handle);
  if ($debug) print("Released exclusive lock\n");
  return(0);
}

?>
