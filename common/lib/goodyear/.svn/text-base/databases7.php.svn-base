<?php

// REWRITTEN to USE ZEND DB INSTEAD of PEAR MDB2
use Zend\Db\Adapter\Adapter;
use Zend\Db\ResultSet\ResultSet;

function open_db($db_name) {
  $debug=TRUE;
  $debug=FALSE;
  if (is_string($db_name)) {
    switch($db_name) {

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
        $options = array(
          'driver'   => 'oci8',
          'hostname'  => '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ahqgdb1p)(PORT = 1541))) (CONNECT_DATA = (SERVICE_NAME = ASM01P.world)))',
          'charset'   => 'utf8',
          'username'  => 'ldam',
          'password'  => 'gy2011assetmanager',
        );
      break;

      case 'amtest':
        $options = array(
          'driver'   => 'oci8',
          'hostname'  => '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ahqgdb1t)(PORT = 1541))) (CONNECT_DATA = (SERVICE_NAME = ASM01T.world)))',
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
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=ahqgdb1p.akr.goodyear.com)(PORT=1534))(CONNECT_DATA=(SERVICE_NAME=svc01t.world)))',
          'charset'   => 'utf8',
          'username'  => 'ld66039',
		  'password'  => 'c0nn3ct1tadm1n',
        );
      break;

	  case 'hpsm_development':	// Dev HP SM - added 5/23/2017 AS
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = akrdbsvc01d)(PORT = 1566))) (CONNECT_DATA = (SERVICE_NAME = SVC01D.world)))',
          'charset'   => 'utf8',
          'username'  => 'ld66039',
		  'password'  => 'c0nn3ct1tadm1n',
        );
      break;

	  case 'hpsm_test':	// Test HP SM - added 5/23/2017 AS
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = akrdbsvc01t)(PORT = 1568))) (CONNECT_DATA = (SERVICE_NAME = svc01t.world)))',
          'charset'   => 'utf8',
          'username'  => 'ld66039',
		  'password'  => 'c0nn3ct1tadm1n',
        );
      break;

	  case 'hpsm_production':	// Prod HP SM - added 5/23/2017 AS
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ahqgdb2p)(PORT = 1541))) (CONNECT_DATA = (SERVICE_NAME = svc01p.world)))',
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
      case 'nidb_production':
        $options = array(
          'driver'    => 'mysqli',
          'hostname'  => 'gsno.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'assetmanager',
          'password'  => 'hpam2007',
          'charset'   => 'utf8',
        );
      break;

	  case 'nidb_test':
        $options = array(
          'driver'    => 'mysqli',
          'hostname'  => 'akrlx261.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'assetmanager',
          'password'  => 'hpam2007',
          'charset'   => 'utf8',
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
	  'charset'   => 'utf8',
        );
      break;

      case 'nidb_qualys_test':
        $options = array(
          'driver'    => 'mysqli',
          'hostname'  => 'akrlx261.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'qualys',
          'password'  => 'sylauq',
          'charset'   => 'utf8',
        );
      break;

      case 'nidb_qualys_production':
        $options = array(
          'driver'    => 'mysqli',
          'hostname'  => 'gsno.akr.goodyear.com',
          'port'      => '3306',
          'database'  => 'inventory',
          'username'  => 'qualys',
          'password'  => 'sylauq',
          'charset'   => 'utf8',
        );
      break;

// GAIMS DATABASES
      case 'gaims_production':
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=ahqgdb1p.akr.goodyear.com)(PORT=1534))(CONNECT_DATA=(SERVICE_NAME=dbx04p.world)))',
          'charset'   => 'utf8',
          'username'  => 'ld66039',
	  'password'  => 'g1ta55mt',
        );
      break;

//ALTIRIS DATABASES
	  case 'altiris_na':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsmpsqlna02.akr.goodyear.com',
          'database'  => 'Symantec_CMDB_NA_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;
	  case 'altiris_la':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsmpsqlna03.akr.goodyear.com',
          'database'  => 'Symantec_CMDB_LA_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;
	  case 'altiris_ap':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'sgcaltdbsv2.ap.ad.goodyear.com',
          'database'  => 'Symantec_CMDB_AP_Region',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;
	  case 'altiris_ec':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'eclvms574.ec.ad.goodyear.com',
          'database'  => 'Symantec_CMDB',
          'username'  => 'LDA2409',
          'password'  => '9Yb1Iq9Fn8Ck6Vd',
        );
      break;

// CURION DATABASES - NOTE ONLY CREDENTIALS CHANGE ***
      case 'courion_production':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsql2008na1.na.ad.goodyear.com',
          'database'  => 'CourionP',
          'username'  => 'LDSNADP',
          'password'  => 'WeLoveIntegratingWithGAIMS2Prod',
        );
      break;
      case 'courion_test':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsql2008na1.na.ad.goodyear.com',
          'database'  => 'CourionP',
          'username'  => 'LDSNADT',
          'password'  => 'WeLoveIntegratingWithGAIMS2Test',
        );
      break;
      case 'courion_development':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsql2008na1.na.ad.goodyear.com',
          'database'  => 'CourionP',
          'username'  => 'LDSNADD',
          'password'  => 'WeLoveIntegratingWithGAIMS2Dev',
        );
      break;


// FLEXERA DATABASES
      case 'flexera_production':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsqlflexpna2.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3002',
          'password'  => 'honeybadgerflex',
        );
      break;

      case 'flexera_test':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsqlflextna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3648',
          'password'  => '23sXmCx839vCXbea',
       );
     break;

      case 'flexera_old_test':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrflexsqltna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3648',
          'password'  => 'honeybadgerflext',
       );
     break;

     case 'flexera_development':
       $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsqlflexdna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3696',
          'password'  => 'Ack84xvVM46rrxjj',
       );
     break;

     case 'flexera_old_development':
       $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrflexsqldna1.akr.goodyear.com',
          'database'  => 'FNMP',
          'username'  => 'lda3696',
          'password'  => 'honeybadgerflexd',
       );
     break;

// HPOM DATABASES
      case 'hpom_production':
        $options = array(
          'driver'    => 'oci8',
          'hostname'  => '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=ahqgdb2p.akr.goodyear.com)(PORT=1541))(CONNECT_DATA=(SERVICE_NAME=oml01p.world)))',
          'charset'   => 'utf8',
          'username'  => 'opc_op',
          'password'  => 'gy_op',
        );
      break;

    default:
      echo "Database name not defined: ".$db_name;
      return(FALSE);
      break;
    }
  }

  $db = new Adapter($options);
  return($db);
}

function get_records($db,$sql) { // Get all the results as 2 dimensional array[index][column_header]
  $statement=$db->query($sql);
  $result=$statement->execute();
  // ****** GET ALL THE ROWS IN BIG ARRAY *******************
  $resultSet= new ResultSet; $resultSet->initialize($result);
  $result_arr=$resultSet->toArray();
  return($result_arr);
}

function getrowfromdb($db,$sql) {
  $debug=TRUE;
  $debug=FALSE;
  if ($debug) print("start ***".__FUNCTION__."***\n");
  $statement = $db->query($sql);
  $result=$statement->execute();
  if ($debug) {
    print("end ***".__FUNCTION__." ***\n");
  }
  if($result===NULL) {
    return(NULL);
  } else {
    return($result->current());
  }
}

function getcolfromdb($db,$sql,$colnum=0) {    // GET One column of data from SQL response and return as simple array[index]
    $answer = $db->getCol($sql,NULL,NULL,NULL,$colnum);
    if (PEAR::isError($answer)) {
        println("sql=$sql");
        die("<pre>".$answer->getMessage()."\n".$answer->getUserinfo()."</pre>");
    }
    return($answer);
}

function getonefromdb($db,$sql) {
  $statement = $db->query($sql);
  $result = $statement->execute();
  if (!$result->current()) {
    return('');
  } else {
    return(current($result->current()));
  }
}

/**
 * @param \Zend\Db\Adapter\Adapter $db
 * @param string $sql
 *
 * @return \Zend\Db\Adapter\Driver\ResultInterface|\Zend\Db\Adapter\Driver\StatementInterface|\Zend\Db\ResultSet\ResultSet
 */
function db_exec_check(Adapter $db, string $sql)
{
  try
  {
    $statement = $db->query($sql);
    $result = $statement->execute();
    return ($result);
  }
  catch (Exception $e)
  {
    MarkObject($e);
    GetCallstack();
    throw $e;
  }
}

function db_update(Adapter $db, string $table, array $values, string $where)
{
  try
  {
    $result = $db->update($table, $values, $where);
    return $result;
  }
  catch (Exception $e)
  {
    MarkObject($e);
    GetCallstack();
    throw $e;
  }
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
