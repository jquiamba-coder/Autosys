<?php
//
// 2015-07-15 Patrick Volz, Class to tail a file, usually a log
// 2015-07-30 Patrick Volz, Simplified, added getpos() so can track position processed in file.
//
class Tail {
  private $filename = '';
  private static $last_pos = 0;
  private static $status_file = '';
  private $usleep = 300000; // 0.3 seconds
  private $start_read_eof=TRUE;
  private $return_empty=TRUE;

  function __construct($filename,$status_file='',$start_read_eof=TRUE) {
    $this->filename = $filename;
    $stored_pos=FALSE;
    if ($status_file!='') {
      $this->status_file=$status_file;
      $status_contents=file_get_contents($status_file);
      if (!($status_contents===FALSE)) {
        $stored_last_pos=(integer)trim($status_contents);
        $stored_pos=TRUE;
      }
    } 
    $file_length=filesize($filename);
    if ($stored_pos) {
      if ($stored_pos>$file_length) {
        $this->last_pos=0;
      } else {
        $this->last_pos=$stored_last_pos;
      }
    } else {
      if ($start_read_eof) {
        $this->last_pos=$file_length;
      } else {
        $this->last_pos=0;
      }
    }  
  }
 
  public function getpos() {
    return($this->last_pos);
  }

  public function getline() {
    while (TRUE) {
      clearstatcache(FALSE, $this->filename);
      $file_length = filesize($this->filename);
      if ($file_length < $this->last_pos) { //file deleted or reset
        $this->last_pos=0;
      } elseif ($file_length > $this->last_pos) {  // something more to read
        $f = fopen($this->filename, "rb");
        if ($f === FALSE) die();
        fseek($f, $this->last_pos);
        while (!feof($f)) {
          $line = fgets($f,4096);
	  $this->last_pos=ftell($f);
          file_put_contents($this->status_file,$this->last_pos);
	  fclose($f);
          return ($line);
        }
      } else {
        if ($this->return_empty) return(FALSE); // there was no more lines found
        usleep($this->usleep);  // wait for the file to change
      }
    }
  }
}
