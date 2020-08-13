<?php

// test_whoami();
// Identify the script, directory, and server instantiating this class
// Operating System independent
class Whoami {
  var $server_hostname='';
  var $server_fqdn='';
  var $caller_file='';
  var $caller_basename='';
  var $caller_filename='';
  var $caller_dir='';

  function __construct() {

    $this->server_hostname=strtolower(gethostname());
    $this->server_fqdn=strtolower(gethostbyaddr(gethostbyname($this->server_hostname)));

    $backtrace=debug_backtrace();
    if(empty($backtrace[1])) {
      $this->caller_file=$backtrace[0]['file'];
    } else {
      $this->caller_file=$backtrace[1]['file'];
    }

    $path_parts=pathinfo($this->caller_file);
    $this->caller_basename=$path_parts['basename'];
    $this->caller_dir=$path_parts['dirname'];
    $this->caller_filename=$path_parts['filename'];
  }
}

function test_whoami() {
  $sender= new Whoami();
  print("$sender->server_fqdn\n");
  print("$sender->server_hostname\n");
  print("$sender->caller_file\n");
  print("$sender->caller_basename\n");
  print("$sender->caller_dir\n");
}

?>
