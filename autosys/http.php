#!/usr/bin/php
<?php
require_once('simple_html_dom.php');

$notes_server='ahqna401';

$userid='ldnidb1';
$password='9Yf1Mu2Nv1Px1Mu';
$jobname='NAT_P_PP_C_D_*';
$jobname='NAT_P_PP_C_D_YIVR1000';
$doc_reference="/corp/finance/phonefil.nsf/49f85bf232c7bcee85256869005b8e1c?SearchView&&Query=$jobname";

$url="http://$userid:$password@$notes_server$doc_reference";
print("$url\n");
$html=file_get_html($url);
$list_references=$html->find('a');
$count=count($list_references);

if ($count==0) {
  print("No phone file document found\n");
} else if ($count>1) {
  print("More than 1 phone file document found:\n");
  foreach($list_references as $reference) {
    print($reference->href."\n");
  }
} else {
  print"\nJust 1 phone file document found: ";
  $doc_reference=$list_references[0]->href;
  print("$doc_reference\n");

  $html->clear(); unset($html);
  $url="http://$userid:$password@$notes_server$doc_reference";
  $html=file_get_html($url);
  $table=$html->find('table',1);
  $table_rows=$table->find('tr');
  foreach($table_rows as $row_num => $table_row) {
    $var='contact_'.$row_num+1;

    print("\n");
    print("$table_row");
    print($table_row->find('td',2)->innertext);
    $$var=$table_row->find('td',2)->innertext;
    print("\n");
  }
  print("contact_1=$contact_1\n");
  print("contact_2=$contact_2\n");
  print("contact_3=$contact_3\n");
}

exit;
?>
