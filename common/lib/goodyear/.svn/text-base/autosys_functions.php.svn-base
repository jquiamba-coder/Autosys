<?php

define ('JOB_TYPE_BOX',98);
define ('JOB_TYPE_CMD',99);
define ('JOB_TYPE_FW',102);

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

?>
