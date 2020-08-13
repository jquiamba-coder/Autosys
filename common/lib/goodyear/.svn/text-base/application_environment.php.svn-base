<?php

function get_application_environment()  {
  $application_environment=getenv('application_environment');
  if (!empty($application_environment)) {
    $valid_choices=array('development','test','production');
    if (in_array($application_environment,$valid_choices)) {
      return($application_environment);
    } else {
      return('unknown');
    }
  }
  $hostname=strtolower(gethostname());

  switch ($hostname) {

  case 'akrlx232': // AUTOSYS PRIMARY
  case 'akrlx234': // AUTOSYS SECONDARY
  case 'akrlx284': // NIDB Ohio
  case 'eclvms436': // NIDB Lux
  case 'akrgstwpna01': // Core Windows2016
  case 'akramcitna1': // HP Asset Manager ConnectIt
    return('production');
  break;

  case 'akrlx261':  // NIDB
  case 'akrlx322':  // AUTOSYS
  case 'akrgstwtna01': // NIDB Windows2016
  case 'akritimdstna1': // Core Windows2016
    return('test');
  break;

  case 'akrgstwdna01': // Core Windows2016
  case 'akrlx271': // AUTOSYS
  case 'akrlx246': // NIDB RHEL 7+
    return('development');
  break;

  default:
    return('unknown');
  break;

  }
}

