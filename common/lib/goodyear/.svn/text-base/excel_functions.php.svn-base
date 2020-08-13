<?php
require_once 'PHPExcel.php'; // for PHP EXCEL

function create_xlsx($records) {
/**
 * Fill worksheet from values in array
 *
 * @param   array   $source                 Source array
 * @param   mixed   $nullValue              Value in source array that stands for blank cell
 * @param   string  $startCell              Insert array starting from this cell address as the top left coordinate
 * @param   boolean $strictNullComparison   Apply strict comparison when testing for null values in the array
 * @throws Exception
 * @return PHPExcel_Worksheet
 */
  $objPHPExcel = new PHPExcel();
  $header_row=array_keys(current($records));
  $objPHPExcel->getActiveSheet()->fromArray($header_row, NULL, 'A1');  // Fill Header Row
  $objPHPExcel->getActiveSheet()->fromArray($records, NULL, 'A2');     // Fill data
  $objPHPExcel->getActiveSheet()->getStyle('A1:'.$objPHPExcel->getActiveSheet()->getHighestColumn().'1')
	  ->getFont()->setBold(true);  // Set Header Row font to BOLD
  return($objPHPExcel);
}

function write_xlsx($objPHPExcel,$filename) {
  $objWriter2007 = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
  $objWriter2007->save($filename);
}

function read_xlsx($xlsx) {
  $debug=TRUE;
  $debug=FALSE;
  include_once 'PHPExcel/IOFactory.php';
  $objPHPExcel = PHPExcel_IOFactory::load($xlsx);
  $objPHPExcel->setActiveSheetIndex(0);
  $aSheet = $objPHPExcel->getActiveSheet();

  $array = array();

  foreach($aSheet->getRowIterator() as $row){
    $cellIterator = $row->getCellIterator();
    $item = array();
    foreach($cellIterator as $cell){
      if ($debug) println("cell->getCalulatedValue=".$cell->getCalculatedValue());
      $cell_calculated=$cell->getCalculatedValue();
      $conversion_result=iconv('utf-8', 'cp1251',$cell_calculated);
      if ($conversion_result===FALSE) {
        array_push($item, "");
      } else {
        array_push($item, iconv('utf-8', 'cp1251', $cell_calculated));
      }
    }

  array_push($array, $item);
  }
  $objPHPExcel->disconnectWorksheets();
  unset($objPHPExcel);
	

  for($i=0;$i<sizeof($array[0]);$i++){
    for($j=1;$j<sizeof($array);$j++){
      $outputArray[$j-1][$array[0][$i]]=trim($array[$j][$i]);
    }
  }
  return $outputArray;
}

?>
