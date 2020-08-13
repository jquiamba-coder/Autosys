<?php

class sftp_client {
  public $server='localhost';
  public $port=22;
  public $fqfn_remote;
  public $ssh_auth_user;
  public $ssh_auth_pass;
  public $error = FALSE;
  public $error_message = '';
  private $connection;
  private $sftp;

  function getErrorMessage() {
    return $this->error_message;
  }
  
  function __construct($vars) {
    $this->server=$vars['server'];
    if (empty($vars['port'])) {
      $this->port=22;
    } else {
      $this->port=$vars['port'];
    }
    $this->ssh_auth_user=$vars['ssh_auth_user'];
    $this->ssh_auth_pass=$vars['ssh_auth_pass'];

    // SSH CONNECT
    if (!$this->connection=@ssh2_connect($this->server,$this->port)) {
      $this->error=TRUE;
      $this->error_message="Cannot connect to server:'$this->server' on port $this->port";
    }
    // SSH AUTHENTICATE
    if (!@ssh2_auth_password($this->connection,$this->ssh_auth_user,$this->ssh_auth_pass)) {
      $this->error=TRUE;
      $this->error_message="Autentication rejected by server for user='$this->ssh_auth_user' and pass='$this->ssh_auth_pass'";
    } 
    // SFTP CLIENT
    if (!$this->sftp=@ssh2_sftp($this->connection)) {
      $this->error=TRUE;
      $this->error_message="Cannot open sftp client";
    }
  }

  function getfile($fqfn_remote) {
    $this->fqfn_remote=$fqfn_remote;
    // OPEN STREAM
    if (!$stream = fopen("ssh2.sftp://$this->sftp$this->fqfn_remote", 'r')) {
      $this->error_message="Failed to open stream";
      return(FALSE);
    }
    // GET STREAM FILE CONTENTS
    if (!$string= stream_get_contents($stream)) {
      print("Failed to get file contents\n");
      return(FALSE);
    } else {
      return($string);
    }
  }

}

