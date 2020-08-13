<?php

//test_ipv4_primary();

function test_ipv4_primary() {
  $answer1=ipv4_primary(array('10.1.0.9','10.2.3.4'));
  print("answer1=".print_r($answer1,TRUE)."\n");

  $answer2=ipv4_primary('10.1.1.2, 10.2.3.4 , 224.1.2.3, 192.168.0.99');
  print("answer2=".print_r($answer2,TRUE)."\n");
  
}

function ipv4_primary($ip_list=array(),$return_type='string') {
  // Place networks here that you want excluded ...
  $ipv4_networks_excluded=array(
    array('network'=>'192.160.0.0','mask'=>'255.255.0.0'),
    array('network'=>'169.254.0.0','mask'=>'255.255.0.0'),
    array('network'=>'224.0.0.0','mask'=>'255.0.0.0'),
  );
  $debug=TRUE;
  $debug=FALSE;

  if($debug) print_r($ipv4_newtworks_excluded);

  $ip_list_arr_int=array(); // MAKE all inputs to this standard data form

  $list_type=gettype($ip_list);
  if ($debug) print("list_type=$list_type\nlist=".print_r($ip_list,TRUE));
  switch ($list_type) {
  
    case 'string':
      $ip_list_arr_str=array_map('trim',explode(',',$ip_list));
      if ($debug) print("ip_list_arr_str=".print_r($ip_list_arr_str,TRUE)."\n");
      foreach ($ip_list_arr_str as $ip_str) {
        $ipv4_int=ip2long($ip_str);
        if ($ipv4_int!==FALSE) $ip_list_arr_int[]=$ipv4_int;
      }
    break;

    case 'array':
      foreach ($ip_list as $key=>$value) {
        $element_type=gettype($value);
        if ($element_type=='string') {
          $ipv4_int=ip2long($value);
          if ($ipv4_int!==FALSE) $ip_list_arr_int[]=$ipv4_int;
        } elseif ($element_type='integer') {
          $ip_list_arr_int[]=$value;
        } else {
          print("unexpected ip element type of '$element_type'\n");
          return(FALSE);
        }
      }
    break;
      
    default:
      if ($debug) print("unexpected ip_list type of '$list_type'\n");
      if ($return_type=='string') {
        return('0.0.0.0');
      } else {
        return(0);
      }
    break;
  }

// Should be an array of integers at this stage:
  $number_of_ipv4s=count($ip_list_arr_int);
  if ($debug) {
    print("number of ipv4s supplied=$number_of_ipv4s\n");
    print("ip_list_arr_int=".print_r($ip_list_arr_int,TRUE)."\n");
  }
  switch ($number_of_ipv4s) {

    case 0:
    $primary_ipv4=0;
    break;

    case 1:
    $primary_ipv4=$ip_list_arr_int[0];
    break;

    default:
    foreach ($ip_list_arr_int as $key=>$value) {
      // Discard 192.168.x.x, 224.x.x.x, 169.x.x.x 
      foreach ( $ipv4_networks_excluded as $ip_network_exclude ) {
        if ($value&ip2long($ip_network_exclude['mask'])==$ip_network_exclude['network']) {
          unset ($ip_list_arr_int[$key]);
	}
      }
    }
    if (empty($ip_list_arr_int)) {
      $primary_ipv4=0;
    } else {
      $primary_ipv4=min($ip_list_arr_int);
    }
    break;

  }


  if ($return_type=='string') {
    return(long2ip($primary_ipv4));
  } else {
    return($primary_ipv4);
  }
}

?>
