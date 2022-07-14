#!/usr/bin/perl
open (OUTFILE, ">/var/autosys/prd/int/working/boxes01.dat") or die "Can't open the file name: $!\n";
open (LOG, '//opt/cascripts/shell/autosystools/autotool/export/autorepall.txt');
$scriptpath = "/opt/cascripts/shell/globerrs3.sh";
$scriptserver = "/akrsrv315.na.goodyear.com";
$savejob = ' ';
$savetyp = ' ';
$ADM = 0;
$THR = 0;
$OPS = 0;
$inp = 0;
$err = 0;
$com = 0;
$wat = 0;
$box = 0;
$t1 = 0;
$t2 = 0;
$sw = 'no';
$boxsw = 'no';
@jtab = ();
@tab1 = ();
@tab2 = ();

print OUTFILE "Server - $scriptserver\n";
print OUTFILE "Path   - $scriptpath\n\n";

while (<LOG>) {


          if ($_ =~ 'job_type: BOX')

                 { 
	            $box ++;		 
                    $boxsw = 'yes';
                    $savejob     = (split)  [1];
                    $savetyp = 'b';
                                   }

         elsif ($_ =~ 'insert_job: ADM'){
		$boxsw = 'yes';
		$ADM ++;
					}
	 elsif ($_ =~ 'insert_job: OPS'){
		$boxsw = 'yes';
		$OPS++;
					}	
	 elsif ($_ =~ 'insert_job: VOL'){
                $boxsw = 'yes';
                                        }

         elsif ($_ =~ 'insert_job: AGL'){
                $boxsw = 'yes';		
				        }
	 elsif ($_ =~ 'insert_job: TMS_P_PL_C_Z_FREIGHT_ORD_WALMART'){
		$boxsw = 'yes';
					}
	 elsif ($_=~ 'resources: \(t'){
	        $boxsw = 'yes';
		$THR ++;  
      					 }	 				
	 elsif ($_ =~ 'job_type: fw')

                 {  &conchk;
		    $wat = ($wat + 1);
                    $boxsw = 'no';
                    $consw = 'no';
                    $savejob = (split)  [1];
                    $savetyp = 'f';
                                   }

          elsif ($_ =~ 'job_type: CMD')

                 {  &conchk;
                    $com = ($com + 1);
                    $boxsw = 'no';
		    $consw = 'no';
                    $savetyp = 'c';
                    $savejob     = (split)  [1];
                                   }
          elsif ($boxsw =~  'no')
             {   &comm; }
                                    }


 sub comm     {
                   if ($_ =~ 'condition: v')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition: \(v')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition: s')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition: d')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition: \(\(v')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition: t')
                   {    $consw = 'yes';
                        $boxsw = 'yes'; }
                 elsif ($_ =~ 'condition:')
                {
                 $jtab[$inp] = $savejob;
                 $inp = ($inp + 1);
                 $consw = 'yes';
                  print  OUTFILE "$savejob   - $_  \n";
                  $err = ($err + 1);
                   }
            		  }

  sub conchk  {
                 if ($savetyp =~ 'b')
                   {  }
                 elsif ($consw =~ 'no')

                 {  print  OUTFILE "$savejob   - no condition or threshold resources  \n\n";
                    $err = ($err + 1);
                          }  }

print  OUTFILE "Total THR Jobs  - $THR\n";
print  OUTFILE "Total ADM Jobs  - $ADM\n";
print  OUTFILE "Total OPS Jobs  - $OPS\n";
print  OUTFILE "Total commands  - $com\n";
print  OUTFILE "Total watch fi  - $wat\n";
print  OUTFILE "Total errors    - $err\n";
print  OUTFILE "Total Boxes     - $box\n";
close LOG;
close OUTFILE;
