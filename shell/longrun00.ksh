#!/usr/bin/perl
########################################################################
# Script: longrun00.ksh   Author: Joe Funk                             #
# Script looks for long running jobs. Does many calculations to        #
# determine the runtime of a job.                                      # 
#                                                                      #
# Update to run on the Local host without requirment for NFS mount     #
########################################################################
$emailsw   = 'yes';
$starttime = ' ';
$endtime   = ' ';
$startdate = ' ';
$dayhh = 0;
$runhh = 0;
$latehh = 8;
$day = 0;
$lhh = 0;
$latek = 0;
$enddate   = ' ';
$jobname   = ' ';
$febdays   = 28;
###############################################
# Reads the output from the AUTOREP -s command#
###############################################
open (CHLOG, '/var/autosys/prd/int/working/longrun_a.dat');
open (OUTFILE, ">/var/autosys/prd/int/working/longrun00.dat") or die "Can't open outfile: $!\n";

print "$currdate \n";
($day_of_mon, $month, $year) = (localtime) [3,4,5];
print "current date - $currdate --- $year\n";
###########################################################################
#  replaces 1 - 9 with a leading zero for date comparison                 # 
###########################################################################
if ($day_of_mon == 1)
    { $day_of_mon = '01'; }    
if ($day_of_mon == 2)
    { $day_of_mon = '02'; }    
if ($day_of_mon == 3)
    { $day_of_mon = '03'; }    
if ($day_of_mon == 4)
    { $day_of_mon = '04'; }    
if ($day_of_mon == 5)
    { $day_of_mon = '05'; }    
if ($day_of_mon == 6)
    { $day_of_mon = '06'; }    
if ($day_of_mon == 7)
    { $day_of_mon = '07'; }    
if ($day_of_mon == 8)
    { $day_of_mon = '08'; }    
if ($day_of_mon == 9)
    { $day_of_mon = '09'; }    

$month  += 1;
$year += 1900;
if ($month == 1)
    { $month = '01'; }    
if ($month == 2)
    { $month = '02'; }    
if ($month == 3)
    { $month = '03'; }    
if ($month == 4)
    { $month = '04'; }    
if ($month == 5)
    { $month = '05'; }    
if ($month == 6)
    { $month = '06'; }    
if ($month == 7)
    { $month = '07'; }    
if ($month == 8)
    { $month = '08'; }    
if ($month == 9)
    { $month = '09'; }    

($min, $hours) = (localtime) [1,2];
$currdate = "after calculations - $month/$day_of_mon/$year";
print "current date - $currdate --- $year\n";
$chh = $hours;
$cmm = $min;
$leapyr = $year / 4;

print  "time: -- $hours:$min  - date:- $month/$day_of_mon/$year   \n";
print  "                           \n";
print OUTFILE "time: -- $hours:$min  - date:- $month/$day_of_mon/$year   \n";
print OUTFILE "                           \n";


while (<CHLOG>) {
   $endtime   = (split)    [5]; 
   $enddate   = (split)    [4]; 
   $starttimemin = (split) [3]; 
   $starttimehr = (split)  [2]; 
   $shh = substr($starttimehr, 0, 2);
   $smm = substr($starttimehr, 3, 2);
   $startdate = (split)    [1]; 
   $smonth = substr($startdate, 0,2);
   $sday   = substr($startdate, 3,2);
   $syear   = substr($startdate, 6,4);
   $jobname   = (split)    [0]; 

if (  $smm =~ 59  )
      { $summ = '58' }; 


if ( / RU /i )
     { print "start - $_ \n";
       $rhh =0;
       &tdate;
       &runjob; } 


$starttime = ' ';
$endtime   = ' ';
$startdate = ' ';
$enddate   = ' ';
$dayhh     = 0;

                                            }

if ($latek =~ 0)
  { print OUTFILE "                           \n";
    print OUTFILE " No jobs are running long. \n"; }

close CHLOG;
close OUTFILE;
&emailnot; 
	     

############################################################
# When the start date is less then the current date        #
############################################################
sub runjob { if ($startdate lt $currdate)
                
             {$emailsw = 'yes'; 
	      &ctime;

              $starttime = ' ';  
                                  } 
	                            }

############################################################
# When the start date is = to the current date             # 
############################################################
sub tdate     { if ($startdate =~ $currdate)
                 { $rhh = $chh;
		   $rhh = $rhh - $shh;
                   &tmin;  
                   &lmin;  }} 

############################################################
# When the current minutes are greater     than start min  # 
############################################################
sub tmin     { if ($cmm > $smm)
	      {  
               $rmm = $cmm - $smm; 
               print  "$_ \n";
	       &sixty;
	       &late; }}

   { if ($cmm =~ $smm)
	      {  
               $rmm = 1; 
               print  "$_ \n";
	       &sixty;
	       &late; }}

############################################################
############################################################
# When the current minutes are less than start minutes     # 
############################################################
sub lmin     { if ($cmm < $smm)
	      {  
               $rmm = 60   -  $smm; 
               $rmm = $cmm +  $rmm; 
               $rhh = $rhh -  1;
	       &sixty;
	       &late;  }}

sub sixty     { if ($rmm > 60) 
                 {$rmm = $rmm - 60;
		  $rhh = $rhh + 1}}

################################################
# When the run hours exceeded time limit       # 
################################################
sub late    {     print    "stats  - $jobname   -   Startdate - $startdate  Starttime = $shh:$smm   runtime = $rhh:$rmm  run hour - $rhh late hour = $latehh\n";   
      if ($rhh > $latehh) 

            {$emailsw = 'yes'; 
             $latek = $latek + 1; 
             print OUTFILE " long running - $jobname   -   Startdate - $startdate  Starttime = $shh:$smm   runtime = $rhh:$rmm\n";   
             print  " - $jobname   -   Startdate - $startdate  Starttime = $shh:$smm   runtime = $rhh:$rmm\n";   
            }  
           }


sub ctime   { print "$month  -  $smonth\n";
              if ($month eq $smonth) 
	    { $day = $day_of_mon;
	      $day = $day - $sday;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth =~ '12') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth =~ '11') 
	    { $day = 30 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth =~ '10') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; 
              print "late October $jobname  $currdate  $startdate dat = $day dayhh = $dayhh $sday $day_of_mon \n"; }
            elsif ($smonth =~ '09') 
	    { $day = 30 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth =~ '08') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '07') 
	    { $day = 30 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '06') 
	    { $day = 30 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '05') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '04') 
	    { $day = 30 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '03') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '02') 
	    { $day = $febdays;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }
            elsif ($smonth = '01') 
	    { $day = 31 - $sday;
	      $day = $day + $day_of_mon;
              $dayhh = $day * 24;  
	      $dayhh = $dayhh - $shh;
	      $rhh =  $dayhh;
	      $rhh = $rhh + $chh;
	      &tmin;
              &lmin; }}

########################################################################
########################################################################
sub emailnot { $FLATFILE="/var/autosys/prd/int/working/longrun00.dat";
             open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
             open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
             print EMAIL "From: $0\n";
             print EMAIL "To:  serverops\@goodyear.com,ahq.autosys.administrators\@goodyear.com\n";
             print EMAIL "Subject:   Long Running Box Jobs\n\n";
             while ( <FD> )  { print EMAIL "$_"; }
             close(EMAIL); 
close (FD);   }
