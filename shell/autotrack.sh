#!/usr/bin/perl
########################################################################
$day = 0;
$lhh = 0;
$latek = 0;
$enddate   = ' ';
$whodidit = ' ';
$febdays   = 28;
($day_of_mon, $month, $year) = (localtime) [3,4,5];
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
$currdate = "$month/$day_of_mon/$year";
print "current date - $currdate --- $year\n";
$cfg = 0;
$chkk = 0;
$j1 = 0;
$sendk = 0;
$jname=' ';
$operk = 0;
$ld874p1k = 0;
$user  = ' ';
$userk  = 0;
$pdate = date;
($day_of_mon, $month, $year) = (localtime) [3,4,5];
@ctab = ();
$file_tested=qx(ls /opt/CA/WorkloadAutomationAE/autouser.PRO/archive/autotrack_dump* |grep -v log.);
print "$file_tested\n";
open (CFG, $file_tested);
open (OUTFILE, ">/home/ldautop/autotrack.dat") or die "Can't open negmast file: $!\n"; 
open (OUTFILEH, ">>/home/ldautop/autotrack.hist.dat") or die "Can't open outfileh  file: $!\n"; 


while (<CFG>) {
                      $chkuser = substr($_, 0,6); 
			  print " USER = $CHKUSER $_ \n";

	   if ( /::::::::::::::::::::/i ) 
	     {  
	       $cfg = 0; 
	       &dumpem;
	       @ctab = (); 
	       $chkk = 0;
	       $cfg = 0;
	     
	     }


	   elsif ( $chkuser =~ 'user==' ) 
	     {  
	       $cfg = 0; 
	       &dumpem;
	       @ctab = (); 
	       $chkk = 0;
	       $cfg = 0;
	     
	     }





            elsif  ($_ =~ 'Sendevent issued')

	     {  $j1 = (j1 + 1);
		$chkk =($chkk + 1);
	        $ctab[$cfg] = $_;   
                print "cfg - $ctab[$cfg] \n";
	        $cfg = ($cfg + 1 );  
                                      } 
            else  

	     {  $j1 = (j1 + 1);
		&checkem;
	        $ctab[$cfg] = $_;   
	        $cfg = ($cfg + 1 );  }  

                                                       }
                                        
close CFG;

close OUTFILE;

sub dumpem {

   if ($chkk > 3) 
    {print OUTFILE "$whodidit=============================================================\n";
     while ($cfg  <= $#ctab)  {
                          &countem;
			  print OUTFILE $ctab[$cfg];
				 $cfg = $cfg + 1; }}


                                                                 }

sub checkem {
                
               if ($chkk > 0)   
	          {      
	                $chkk = $chkk + 1; }}

sub countem  {

             if  ($ctab[$cfg] =~ '@akrlx')
	            { $user = substr($ctab[$cfg], 0,7); 
                      $user1 = substr($user, 0,1); 
		      &userchk; } 
                   else
	            { $user = substr($ctab[$cfg], 0,7); 
                      $user1 = substr($user, 0,1); 
		      &userchk; }} 

sub userchk  {
                 if ( $user =~ 'ZA05499' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'ZA06769' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'ZA14127' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'ZA05496' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'ZA21230' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'Z018989' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user =~ 'ZA13071' )
		 {   $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user1 =~ 'Z' )
		 {   $operk = ($operk + 1); 
		     $whodidit = operations;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user1 =~ 'l' )
		 {   $ld874p1k = ($ld874p1k + 1); 
		     $whodidit = ld874p1;
		     $sendk = ($sendk + 1);  }
                 elsif ( $user1 =~ 'N' )
		     { $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1); }
                 elsif ( $user1 =~ 'A' )
		     { $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1); }
                 elsif ( $user1 =~ 'T' )
		     { $userk = ($userk + 1); 
		     $whodidit = user;
		     $sendk = ($sendk + 1);
			      }}

$FLATFILE="/home/ldautop/autotrack.dat";
open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
#rint EMAIL "To: joseph_funk\@goodyear.com,serverops\@goodyear.com,david_barber\@goodyear.com,william_reagan\@goodyear.com,patrick_volz\@goodyear.com,mark_minihan\@goodyear.com\n";
print EMAIL "To: serverops\@goodyear.com,ahq.autosys.administrators\@goodyear.com\n";
#rint EMAIL "To: joseph_funk\@goodyear.com\n";
print EMAIL "Subject:   Autosys Sendevents issued\n";
print EMAIL "***************************************\n ";
print EMAIL "*number of sendevents issued --  $sendk\n ";
print EMAIL "*number by operations        --  $operk\n ";
print EMAIL "*number by ld874p1           --  $ld874p1k\n ";
print EMAIL "*number by other users       --  $userk\n ";
print EMAIL "***************************************\n ";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);
close (FD);
print OUTFILEH " autotrack $currdate   sendevents issued -$sendk by ops - $operk  by users - $userk\n "; 
close(OUTFILEH); 

