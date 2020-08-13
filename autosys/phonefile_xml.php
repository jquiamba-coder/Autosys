#!/usr/bin/php
<?php
print("hello world\n");
$documentcollection=simplexml_load_file("phonefile.xml") or die("Error: Cannot create object");
print("goodbye world\n");
foreach ($documentcollection->document as $document) {
  foreach ($document->item as $item) {
    switch((string) $item['name']) { // Get attributes as element indices

    case 'JobName':
      echo 'JobName:'.$item->value."\n";
    break;

    case 'AbendProcedure':
      echo 'AbendProcedure:'.$item->value."\n";
    break;

    }
  }
  $jobname=$document->item[0]->value;
  print("$jobname\n");
  if ($jobname=='NO_ACTION_REQUIRED') {
    print("*************** NO ACTION REQUIRED ******************\n");
  }
}

?>
