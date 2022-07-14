#!/usr/bin/perl 	
open (LOG, '/opt/CA/WorkloadAutomationAE/autouser.PRO/autosys.jobs.jil');
open (OUTFILE, ">/var/autosys/prd/int/working/boxes01.dat") or die "Can't open names of the file: $!\n"; 
$savejob = ' ';
$inp = 0;
$err = 0;
$t1 = 0;
$t2 = 0;
$sw = 'no';
$boxsw = 'no';
@jtab = ();
@tab1 = ();
@tab2 = ();
while (<LOG>) {
$inp = ($inp + 1);


	  

          if ($boxsw =~ 'yes') 
	  
        	{ if ($_ =~ 'condition: v') 
                { &tabload;
		 $jtab[$inp] = $savejob;
		  print OUTFILE "$savejob   - $_  \n";
                  $err = ($err + 1);
                   }  }





          if ($_ =~ 'job_type: CMD') 
                 {  $sw = 'no'; 
		    $boxsw = 'no' }

          if ($_ =~ 'job_type: FW') 
                 {  $sw = 'no'; 
		    $boxsw = 'no' }

          if ($_ =~ 'job_type: BOX') 

                 {  
		    $boxsw = 'yes';
		    $savejob     = (split)  [1];
                                   } 
				    }
 sub tabload { $t1 = 0;
               $t2 = 0; 
               @tab2 = ' ';
               @tab1 = $jtab[inp]; }



  $inp = 0;
   while ($
   inp  <= $#jtab)  {
		       $savejob = $jtab[$inp];
		       $inp = $inp + 1; }
print OUTFILE  "Total errors  - $err\n";
close LOG;
close OUTFILE;

