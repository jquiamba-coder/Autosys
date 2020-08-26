#!/usr/bin/php
<?php
$year='2017';
$path='/opt/CA/WorkloadAutomationAE/autouser.PRD/archive';
echo "\f";
$bus=array('NAT');
$bus=array('ALL');
foreach ($bus as $bu) {
   $months=array('01','02','03','04','05','06','07','08','09','10','11','12');
   foreach ($months as $month) {
      $cmd_results[$bu][$month]=exec("zgrep -e 'STARTING' $path/event_demon.PRD.$month**$year.Z | grep -e '_P_' | wc -l");
#      $box_results[$bu][$month]=exec("zgrep -e 'STARTJOB' $path/event_demon.PRD.$month**$year.Z | grep -e '".$bu.".\+akrsgmw1p' | wc -l");
   }
}

foreach ($bus as $bu) {
#   echo "$bu Boxes\t", implode("\t",$box_results[$bu])."\n";
#   echo "$bu IA_Boxes\t", implode("\t",$iabox_results[$bu])."\n";
   echo "$bu CMD  \t", implode("\t",$cmd_results[$bu])."\n";
}

