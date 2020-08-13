<?php

require_once 'MDB2.php';  // DB independent object

function open_db($dsn) {
  $debug=TRUE;
  $debug=FALSE;
  if (is_string($dsn)) {
    switch($dsn) {

// AUTOSYS DATABASES
      case 'ats11p':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'ats11p.world', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld874p4',
          'password'  => 'ld874p4',
        );
      break;
      
      case 'ats11t':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'ats11t.world', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld874p4',
          'password'  => 'ld874p4',
        );
      break;
      
      case 'ats11d':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'ats11d.world', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld874p4',
          'password'  => 'ld874p4',
        );
      break;

// HP ASSET MANAGER DATABASES
      case 'amprod':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'asm01p', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ldam',
          'password'  => 'gy2011assetmanager',
        );
      break;

      case 'amtest':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'asm01t', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ldam',
          'password'  => 'g1ta55mt',
        );
      break;

// IT CHARGE BACK DB
      case 'tel01p':		// Production Telecom database
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'tel01p.na.ad.goodyear.com',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'username'  => 'telecomadmin',
          'password'  => 'telecom',
        );
      break;

// HP DDMI DATABASES
      case 'ddmiagg':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'akrddmiaggna1.akr.goodyear.com',
          'port'      => '8108',
          'database'  => 'Aggregate',
          'username'  => 'admin',
          'password'  => 'password',
        );
      break;

      case 'ddmi_la_na':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'akrddmina1.akr.goodyear.com',
          'port'      => '8108',
          'database'  => 'Aggregate',
          'username'  => 'ldnidb1',
          'password'  => 'G3rb3r',
        );
      break;

      case 'ddmi_ap_emea':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'eclsrv44.ec.goodyear.com',
          'port'      => '8108',
          'database'  => 'Aggregate',
          'username'  => 'ldnidb1',
          'password'  => 'G3rb3r',
        );
      break;

// HP SERVICE MANAGER DATABASES
      case 'svc01p_ro':	// Production HP SM Read Only
	$dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'svc01p.world',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld66039',
          'password'  => 'c0nn3ct1tadm1n',
        );
      break;

      case 'sar01p_all':	// Production HP SM Read Only
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'sar01p.goodyear.com',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'username'  => 'ld66039',
          'password'  => 'c0nn3ct1tadm1n',
        );
      break;

      case 'svc02t_ro':	// Test HP SM Read Only
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'svc02t.goodyear.com',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'username'  => 'ld66039',
          'password'  => 'c0nn3ct1tadm1n',
        );
      break;      
      
      case 'svc01p_old':
	$dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'svc01p.goodyear.com',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'username'  => 'screport',
          'password'  => 'scrpt1',
        );
      break;

      case 'svc01t_ro':	// Dev HP SM 9.31 Read Only - added 8/23/2013 JJH
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'svc01t.world',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld66039',
          'password'  => 'c0nn3ct1tadm1n',
        );
      break;      

      case 'svc01d_ro':	// Dev HP SM 9.31 Read Only - added 8/23/2013 JJH
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'svc01d.world',  //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld66039',
          'password'  => 'c0nn3ct1tadm1n',
        );
      break;      
															         
// NIDB DATABASES
      case 'nidb':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'gsno.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'assetmanager',
          'password'  => 'hpam2007',
        );
      break;

      case 'nidb_update':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'gsno.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'connectit',
          'password'  => 'titcennoc',
        );
      break;

      case 'nidb_test':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'localhost',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'php',
          'password'  => 'G3rb3r',
        );
      break;

      case 'nidb_production':
        $dsn = array(
          'phptype'   => 'mysqli',
          'hostspec'  => 'localhost',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'php',
          'password'  => 'G3rb3r',
        );
      break;

// GAIMS DATABASES
      case 'gaims':
        $dsn = array(
          'phptype'   => 'oci8',
          'hostspec'  => 'gaims.na.ad.goodyear.com', //needs to be in TNSNAMES.ORA, should be able to TNSPING this name
          'charset'   => 'utf8',
          'username'  => 'ld66039',
	  'password'  => 'g1ta55mt',
        );
      break;

//ALTIRIS DATABASES
      case 'altiris_na':     // Changed from na2 to na 2/17/2015 per Steve McCue's note JJH
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'akrsmpsqlna02.akr.goodyear.com',
          'database'  => 'Symantec_CMDB_NA_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;

      case 'altiris_la':
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'akrsmpsqlna03.akr.goodyear.com',
          'database'  => 'Symantec_CMDB_LA_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;

      case 'altiris_ap':   // Updated 4/20/2015 per Steve McCue's request JJH
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'sgcaltdbsv2.ap.ad.goodyear.com',
          'database'  => 'Symantec_CMDB_AP_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
	);
      break;

      case 'altiris_ec':   // Update 2016-08-22 per Steve McCue
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'eclvms574.ec.ad.goodyear.com',
          'database'  => 'Symantec_CMDB',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;

// FLEXERA DATABASES
      case 'flexera_production':
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'akrsqlflexpna2.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3002',
          'password'  => 'honeybadgerflex',
        );
      break;

      case 'flexera_test':
        $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'akrflexsqltna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3648',
          'password'  => 'honeybadgerflext',
       );
     break;

     case 'flexera_development':
       $dsn = array(
          'phptype'   => 'mssql',
          'hostspec'  => 'akrflexsqldna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3696',
          'password'  => 'honeybadgerflexd',
       );
     break;

      default:
      break;
    }
  }
  $db = MDB2::connect($dsn);
  if (PEAR::isError($db)) {
     die('Could not create database connection. "'.$db->getMessage().'"'."\n".
     print_r($dsn,TRUE));
  }
  $db->loadModule('Reverse');
  $db->loadModule('Extended');

  if ($debug) print_r($db);
  return($db);
}


function get_records($db,$sql) { // Get all the results as 2 dimensional array[index][column_header]
    $result=$db->queryAll($sql,null,MDB2_FETCHMODE_ASSOC);
    if (PEAR::isError($result)) {
       die('Query unsuccessful "'.$sql.'", please check statement! "'.$result->getMessage().'"');
    }
    return $result;
}

function getrowfromdb($db,$sql) {
    $answer= & $db->getRow($sql,NULL,NULL,NULL,MDB2_FETCHMODE_ASSOC);
    if (PEAR::isError($answer)) {
        die("<pre>".$answer->getMessage()."\n".$answer->getUserinfo()."</pre>");
    }
    return($answer);
}

function getcolfromdb($db,$sql,$colnum=0) {    // GET One column of data from SQL response and return as simple array[index]
    $answer= $db->getCol($sql,NULL,NULL,NULL,$colnum);
    if (PEAR::isError($answer)) {
        println("sql=$sql");
        die("<pre>".$answer->getMessage()."\n".$answer->getUserinfo()."</pre>");
    }
    return($answer);
}

function getonefromdb($db,$sql) {
    $answer = $db->getOne($sql);
    if (PEAR::isError($answer)) {
        die("<pre>".$answer->getMessage()."\n".$answer->getUserinfo()."</pre>");
    }
    return($answer);
}

function db_exec_check($db,$sql) {
    $result=$db->exec($sql);
    if (PEAR::isError($result)) {
        die("<pre>".$result->getMessage()."\n".$result->getUserinfo()."</pre>");
    }
    return ($result);
}

//function print_records($result,$type='comma') {
//    $count=0;
//    if ($type!='array') {
//	if ($type=='tab') $separator="\t";
//	if ($type=='comma') $separator=",";
//        print(implode($separator,(array_keys(current($result)))))."\n";
//    }
//    foreach ($result as $set) {
//	$count++;
//	switch($type) {
//	default:
//	case 'tab':
//       	case 'comma':
//	     print(implode($separator,(array_values($set))))."\n";
//	break;
//	
//	case 'array':
//		print("record $count, ".print_r($set,TRUE));
//	break;
//        }
//    }
//}

function read_records($filename,$separator="\t",$skip_lines=0) {
  $debug=TRUE;
  $debug=FALSE;
  $handle=fopen($filename,'r');
  if ($debug) {
    print("filename='$filename'\n");
    print("separator='$separator'\n");
    print("skip_lines='$skip_lines'\n");
  }
  for ($lines_skipped=1; $lines_skipped<=$skip_lines; $lines_skipped++) {
    $line=fgets($handle);
    if ($debug) print ("lines_skipped=$lines_skipped, kipping line=$line");
  }
   $row=0;
   $result=array();
   $headings=fgetcsv($handle, 1000, $separator);
   $row++;
   if ($debug) print('headings='.print_r($headings,TRUE));
   while (($line_data = fgetcsv($handle, 1000, $separator)) !== FALSE) {
      $row++;
      if ($debug) print('line_data='.print_r($line_data,TRUE));
      foreach ($line_data as $index => $value) {
	 $index2=$headings[$index];
         $result[$row-2][$index2]=$value;
      }
   }
   if ($debug) print('result='.print_r($result,TRUE));
   return($result);
   fclose($handle);
}

function format_records($result,$type='tab') {
    $count=0;
    if (empty($result)) {
	return('');
    }
    if ($type!='array') {
	if ($type=='tab') $separator="\t";
	if ($type=='comma') $separator=",";
	$str='';
        $str.=(implode($separator,(array_keys(current($result)))))."\n";
    }
    foreach ($result as $set) {
	$count++;
	switch($type) {
	default:
	case 'tab':
       	case 'comma':
	    $str.=(implode($separator,(array_values($set))))."\n";
	break;
	
	case 'array':
	    $str.=("record $count, ".print_r($set,TRUE));
	break;
        }
    }
    return($str);
}

?>
