<?php

// REWRITTEN to USE ZEND DB INSTEAD of PEAR MDB2
use Zend\Db\Adapter\Adapter;
use Zend\Db\ResultSet\ResultSet;

function open_db($db_name) {
  $debug=TRUE;
  $debug=FALSE;
  if (is_string($db_name)) {
    switch($db_name) {

      //AUTOSYS SQL DATABASE
      case 'autosys_test':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsqlasystna1.na.ad.goodyear.com',
          'database'  => 'AEDBTEST',
          'username'  => 'autosys',
          'password'  => '8FGRTQ8745TTLPSZ683btHitz',
        );
        break;
      case 'autosys_production':
        $options = array(
          'driver'    => 'sqlsrv',
          'hostname'  => 'akrsqlasysna1.na.ad.goodyear.com',
          'database'  => 'AEDBPROD',
          'username'  => 'autosys',
          'password'  => '8FGRTQ8745TTLPSZ683btHitz',
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
