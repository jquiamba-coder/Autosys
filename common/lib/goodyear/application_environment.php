<?php

function get_application_environment() {
  $application_environment = getenv('application_environment');
  if (!empty($application_environment)) {
    $valid_choices = ['development', 'test', 'production'];
    if (in_array($application_environment, $valid_choices)) {
      return ($application_environment);
    }
    else {
      return ('unknown');
    }
  }
  $hostname = strtolower(gethostname());
  switch ($hostname) {
    case 'akrsrv315.na.goodyear.com': // AUTOSYS PRIMARY
    case 'akrsrv316.na.goodyear.com': // AUTOSYS SHADOW
      return ('production');
      break;

    case 'akrsrv317.na.goodyear.com':  // AUTOSYS PRIMARY
    case 'akrsrv318.na.goodyear.com':  // AUTOSYS SHADOW
      return ('test');
      break;

    default:
      return ('unknown');
      break;
  }
}

