#!/usr/bin/perl -w
################################################################	
# S:\660C Share\Autosys>cd logs                                                                             #
# S:\660C Share\Autosys\logs>for %f in (*2009) do type "%f" >> demon.txt#
################################################################
$jobstatus = '  ';
$repdate = '  ';
$rdate = '  ';
$tabk = 0;
$corfik = 0;
$forck = 0;
$natapk = 0;
@ctab = ();
$cindex = 0;
$sfileink = 0;
$akrlxautosysk = 0;
$ahqlpt0k = 0;
$ahqipa1k = 0;
$akrpcdmqk = 0;
$akrsgmw1pk = 0;
$akrgpodbna01k = 0;
$connectedk = 0;
$natapk = 0;
$natpmk = 0;
$natedk = 0;
$natink = 0;
$natimk = 0;
$mantmk = 0;
$natmmk = 0;
$natrbk = 0;
$natcuk = 0;
$natork = 0;
$natopk = 0;
$natibk = 0;
$natcsk = 0;
$natpuk = 0;
$nattlk = 0;
$natsdk = 0;
$ewnk = 0;
$natbik = 0;
$natslk = 0;
$natark = 0;
$yewik = 0;
$eurk = 0;
$natcsk = 0;
$natpuk = 0;
$nattlk = 0;
$natsdk = 0;
$ewnk = 0;
$natbik = 0;
$natslk = 0;
$natark = 0;
$yewik = 0;
$eurk = 0;
$misk = 0;
$totk = 0;
$nathrk = 0;
$natprk = 0;
$natslk = 0;
$natglk = 0;
$natblk = 0;
$natppk = 0;
$retk = 0;
$latk = 0;
$natshk = 0;
$scmk = 0;
$watchk = 0;
$failk = 0;
$termk = 0;
$mank = 0;
&resetk;
open (LOG, '/opt/CA/WorkloadAutomationAE/autouser.PRO/out/event_demon.PRO');
#pen (LOG, '/opt/CA/WorkloadAutomationAE/autouser.PRD/archive/event_demon.PRD.05242014');
#open (OUTFILEH, ">>/home/ld874p1/autojobs.hist.dat") or die "Can't open history file: $!\n"; 
open (OUTFILEH, ">>//home/ldautop/autojobs.hist.dat") or die "Can't open history file: $!\n"; 
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
#rint EMAIL "To: joseph_funk\@goodyear.com\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:   Autosys Jobs Run \n";
while (<LOG>) {

     $jobstatus = $_;

     if ($jobstatus =~ /Scheduler Log/) {
        $repdate = $_;
        $rdate = substr($_,23,11);
        next; 
     }  


     #--
     #-- We ignore any lines that are shorter than the
     #--  location of the information that we need
     #--

     $lineSize = length($jobstatus);
     if ($lineSize < 75) {
         next; 
     }

     #--
     #-- Count jobs by status
     #-- Successful jobs also get sloted by area
     #--

     if ($jobstatus =~ /SUCCESS/) {  
	 $totk = $totk + 1;
         &checkprt; 
         next;
     } 


     if ($jobstatus =~ 'FAILURE') {
         $failk = $failk + 1; 
         next;
     }
    
     if ($jobstatus =~ 'TERMINA') {  
         $termk = $termk + 1; 
         next;
     }

     if ($jobstatus =~ 'FORCE_START')  {  
         $forck = $forck + 1;
         next;
     }          

     #--
     #-- Track jobs by machine 
     #--

     if ($jobstatus =~ 'connected for')  {
         $ctab[$cindex] = $jobstatus;          
         $cindex = ($cindex + 1); 
         next;
     }
		  
}
 
close LOG;
&prtotals;
&resetk;
&dumpem;
&srvtotals;
#&resetk;
#&dumpem1;
#&servtotals1;
close(EMAIL);
close(OUTFILEH); 
sub prtotals {
  print EMAIL "=======$repdate=======\n";  
  print EMAIL "SFILEIN jobs-------------$sfileink\n";  
  print EMAIL "Supply Chain Man-----------$scmk    \n";  
  print EMAIL "Corporate Finance----------$corfik  \n";  
  print EMAIL "COR_P_OP-------------------$coropk  \n"; 
  print EMAIL "COR_P_OR-------------------$corork  \n"; 
  print EMAIL "COR_P_BL-------------------$corblk  \n"; 
  print EMAIL "Latin America--------------$latk    \n";
  print EMAIL "NAT Accounts Rec-----------$natark  \n";  		
  print EMAIL "NAT Accounts Pay-----------$natapk  \n";
  print EMAIL "NAT Human Resc-------------$nathrk  \n";
  print EMAIL "NAT_P_GL-------------------$natglk  \n"; 
  print EMAIL "NAT_P_OR-------------------$natork  \n"; 
  print EMAIL "NAT_P_OP-------------------$natopk  \n"; 
  print EMAIL "NAT_P_CS-------------------$natcsk  \n"; 
  print EMAIL "NAT_P_CU-------------------$natcuk  \n"; 
  print EMAIL "NAT_P_RB Rebates-----------$natrbk  \n"; 
  print EMAIL "NAT_P_BL-------------------$natblk  \n"; 
  print EMAIL "NAT_P_MM-------------------$natmmk  \n"; 
  print EMAIL "NAT Shipping---------------$natshk  \n";
  print EMAIL "NAT_P_SL-------------------$natslk  \n";
  print EMAIL "NAT_P_BI-------------------$natbik  \n";
  print EMAIL "NAT_P_PU-------------------$natpuk  \n";  
  print EMAIL "COR_P_IB-------------------$natibk  \n";  
  print EMAIL "NAT Prod Plan--------------$natppk  \n";
  print EMAIL "NAT Inventory--------------$natink  \n";
  print EMAIL "NAT Optimiza---------------$natimk  \n";
  print EMAIL "NAT EDI--------------------$natedk  \n";
  print EMAIL "Miscellaneous apps---------$misk    \n";  
  print EMAIL "Retail jobs----------------$retk    \n";  	
  print EMAIL "EWM     -------------------$ewmk    \n"; 
  print EMAIL "EUR jobs-------------------$eurk    \n";  	
  print EMAIL "TMS jobs-------------------$mantmk  \n";
  print EMAIL "Manugistics jobs-----------$mank    \n";
  print EMAIL "Trilogy jobs---------------$nattlk  \n";
  print EMAIL "EWM jobs-------------------$natsdk  \n";
  print EMAIL "EDW jobs-------------------$yewik   \n";	
  print EMAIL "Watchfile jobs-------------$watchk  \n";  		
  print EMAIL "Total success jobs---------$totk    \n";
  print EMAIL "Total failures-------------$failk   \n";
  print EMAIL "Total Terminated-----------$termk   \n";
  print EMAIL "Jobs Force Started---------$forck   \n";
  print OUTFILEH "$rdate - SUCCESS - $totk  FAILURES - $failk  \n";
	     } 
sub srvtotals  {
  print EMAIL "======================================= \n";
  print EMAIL "Jobs on server akrsgpas----$akrlxautosysk   \n";
  print EMAIL "Jobs on server ahqlpt0-----$ahqlpt0k   \n";
  print EMAIL "Jobs on server ahqipa1-----$ahqipa1k   \n";
  print EMAIL "Jobs on server akrsgmw1p----$akrsgmw1pk   \n";
  print EMAIL "Jobs on server akrpcdmq----$akrpcdmqk   \n";
  print EMAIL "Jobs on    akrgpodbna01----$akrgpodbna01k   \n";
  print EMAIL "total connections      ----$connectedk   \n";
  print EMAIL " Jobs that run on SAP servers==============\n";
  print EMAIL "       NAT Accounts Rec-----------$natark  \n";  		
  print EMAIL "       Corporate Finance----------$corfik  \n";  
  print EMAIL "       COR_P_OP-------------------$coropk  \n";  
  print EMAIL "       COR_P_OR-------------------$corork  \n";  
  print EMAIL "       COR_P_BL-------------------$corblk  \n";  
  print EMAIL "       Supply Chain Man-----------$scmk    \n";  
  print EMAIL "       Latin America--------------$latk    \n";
  print EMAIL "       NAT Accounts Pay-----------$natapk  \n";
  print EMAIL "       NAT Human Resc-------------$nathrk  \n";
  print EMAIL "       NAT_P_GL-------------------$natglk  \n"; 
  print EMAIL "       NAT_P_BL-------------------$natblk  \n"; 
  print EMAIL "       NAT_P_MM-------------------$natmmk  \n"; 
  print EMAIL "       NAT_P_OR-------------------$natork  \n"; 
  print EMAIL "       NAT_P_OP-------------------$natopk  \n"; 
  print EMAIL "       NAT_P_RB-------------------$natrbk \n"; 
  print EMAIL "       NAT_P_CS-------------------$natcsk  \n"; 
  print EMAIL "       NAT_P_CU-------------------$natcuk  \n"; 
  print EMAIL "       NAT Shipping---------------$natshk  \n";
  print EMAIL "       NAT_P_SL-------------------$natslk  \n";
  print EMAIL "       NAT_P_BI-------------------$natbik  \n";
  print EMAIL "       COR_P_IB-------------------$natibk  \n";
  print EMAIL "       NAT_P_PU-------------------$natpuk  \n";  
  print EMAIL "       NAT Prod Plan--------------$natppk  \n";
  print EMAIL "       NAT Inventory--------------$natink  \n";
  print EMAIL "       NAT Optimiza---------------$natimk  \n";
  print EMAIL "       NAT EDI--------------------$natedk  \n";
  print EMAIL "       Miscellaneous apps---------$misk    \n";  
  print EMAIL "       EWM jobs-------------------$ewmk    \n";  	
  print EMAIL "       EUR jobs-------------------$eurk    \n";  	
  print EMAIL "       TMS jobs-------------------$mantmk  \n";
  print EMAIL "       Retail jobs----------------$retk    \n";
  print EMAIL "       Manugistics jobs-----------$mank    \n";
  print EMAIL "       Trilogy jobs---------------$nattlk  \n";
  print EMAIL "       EWM jobs-------------------$natsdk  \n";
  print EMAIL "       EDW jobs-------------------$yewik   \n";	
  print EMAIL "       Watchfile jobs-------------$watchk  \n";  		
                                        }
  sub servtotals1
  {
  print EMAIL "Jobs on server akrsgmw1p----$akrsgmw1pk   \n";
  print EMAIL "        akrsgmw1p jobs broken down ======\n"; 
  print EMAIL "       NAT Accounts Rec-----------$natark  \n";  		
  print EMAIL "       Corporate Finance----------$corfik  \n";  
  print EMAIL "       COR_P_OR-------------------$corork  \n";  
  print EMAIL "       COR_P_BL-------------------$corblk  \n";  
  print EMAIL "       Latin America--------------$latk    \n";
  print EMAIL "       Latin America--------------$latk    \n";
  print EMAIL "       NAT Accounts Pay-----------$natapk  \n";
  print EMAIL "       NAT Human Resc-------------$nathrk  \n";
  print EMAIL "       NAT_P_GL-------------------$natglk  \n"; 
  print EMAIL "       NAT_P_BL-------------------$natblk  \n"; 
  print EMAIL "       NAT_P_MM-------------------$natmmk  \n"; 
  print EMAIL "       NAT_P_OR-------------------$natork  \n"; 
  print EMAIL "       NAT_P_OP-------------------$natopk  \n"; 
  print EMAIL "       NAT_P_CS-------------------$natcsk  \n"; 
  print EMAIL "       NAT_P_CU-------------------$natcuk  \n"; 
  print EMAIL "       NAT Shipping---------------$natshk  \n";
  print EMAIL "       NAT_P_SL-------------------$natslk  \n";
  print EMAIL "       NAT_P_PU-------------------$natpuk  \n";  
  print EMAIL "       NAT_P_RB-------------------$natrbk  \n";  
  print EMAIL "       COR_P_IB-------------------$natibk  \n";  
  print EMAIL "       NAT Prod Plan--------------$natppk  \n";
  print EMAIL "       NAT Inventory--------------$natink  \n";
  print EMAIL "       NAT Optimiza---------------$natimk  \n";
  print EMAIL "       NAT EDI--------------------$natedk  \n";
  print EMAIL "       Miscellaneous apps---------$misk    \n";  
  print EMAIL "       EWM jobs-------------------$ewmk    \n";  	
  print EMAIL "       EUR jobs-------------------$eurk    \n";  	
  print EMAIL "       TMS jobs-------------------$mantmk  \n";
  print EMAIL "       Retail jobs----------------$retk    \n";
  print EMAIL "       Manugistics jobs-----------$mank    \n";
  print EMAIL "       EDW jobs-------------------$yewik   \n";	
  print EMAIL "Jobs on    akrgpodbna01----$akrgpodbna01k   \n";
  print EMAIL "total connections      ----$connectedk   \n";
#  print EMAIL "EDW jobs run   ahqipa1 ----$yewik $eurk \n"; } 

sub checkprt 
    {  if ($_ =~ 'SFILEIN')
           {$sfileink = $sfileink + 1 } 
    #   elsif
    #       ($_ =~ '_W_')
    #       {$watchk = ($watchk + 1) } 
       elsif 
          ($_ =~ '_ID_')
           {   $misk = ($misk + 1) }
       elsif 
          ($_ =~ 'EWM')
           {   $ewmk = ($ewmk + 1) }
       elsif
          ($_ =~ '_IA_')
           {   $misk = ($misk + 1) }
       elsif 
          ($_ =~ 'EUR')
           {   $eurk = ($eurk + 1) }
       elsif 
          ($_ =~ 'YEDW')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($_ =~ 'YEWI')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($_ =~ 'CNA_')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($_ =~ 'COR_P_EW_')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($_ =~ 'NAT_P_DW_')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($_ =~ 'NAT_P_RB_')
           {   $yewik = ($natrbk + 1) }
       elsif 
           ($_ =~ 'MAN_P_TM')
           {   $mantmk = ($mantmk + 1) }
       elsif 
           ($_ =~ 'MAN_P_EW')
           {   $mantmk = ($mantmk + 1) }
       elsif 
           ($_ =~ 'MAN_')
           {   $mank = ($mank + 1) }
       elsif 
           ($_ =~ 'COR_P_PU_')
           {   $corfik = ($corfik + 1) }
       elsif 
           ($_ =~ 'COR_P_FI_')
           {   $corfik = ($corfik + 1) }
       elsif 
           ($_ =~ 'LAT')
           {   $latk = ($latk + 1) }
       elsif 
           ($_ =~ 'NAT_P_AR_')
           {   $natark = ($natark + 1) }
       elsif 
           ($_ =~ 'NAT_P_OP_')
           {   $natopk = ($natopk + 1) }
       elsif 
           ($_ =~ 'NAT_P_PM_')
           {   $natpmk = ($natpmk + 1) }
       elsif 
           ($_ =~ 'NAT_P_BI')
           {   $natbik = ($natbik + 1) }
       elsif 
           ($_ =~ 'COR_P_IB')
           {   $natbik = ($natibk + 1) }
       elsif 
           ($_ =~ 'COR_P_OP_')
           {   $coropk = ($coropk + 1) }
       elsif 
           ($_ =~ 'COR_P_OR_')
           {   $corork = ($corork + 1) }
       elsif 
           ($_ =~ 'COR_P_BL_')
           {   $corblk = ($corblk + 1) }
       elsif 
           ($_ =~ 'NAT_P_AP_')
           {   $natapk = ($natapk + 1)}
       elsif 
           ($_ =~ 'NAT_P_ED_')
           {   $natedk = ($natedk + 1)}
       elsif 
           ($_ =~ 'NAT_P_HR_')
           {   $nathrk = ($nathrk + 1)}
       elsif 
           ($_ =~ 'NAT_P_MM_')
           {   $natmmk = ($natmmk + 1)}
       elsif 
           ($_ =~ 'NAT_P_PU_')
           {   $natpuk = ($natpuk + 1)}
       elsif 
           ($_ =~ 'NAT_P_PR_')
           {   $natprk = ($natprk + 1)}
       elsif 
           ($_ =~ 'NAT_P_IN_')
           {   $natink = ($natink + 1)}
       elsif 
           ($_ =~ 'NAT_P_IM_')
           {   $natimk = ($natimk + 1)}
       elsif 
           ($_ =~ 'NAT_P_PP_')
           {   $natppk = ($natppk + 1)}
       elsif 
           ($_ =~ 'NAT_P_SH_')
           {   $natshk = ($natshk + 1) }
       elsif 
           ($_ =~ 'NAT_P_TL_')
           {   $nattlk = ($nattlk + 1) }
       elsif 
           ($_ =~ 'NAT_P_SD_')
           {   $nattlk = ($natsdk + 1) }
       elsif 
           ($_ =~ 'NAT_P_BL_')
           {   $natblk = ($natblk + 1) }
       elsif 
           ($_ =~ 'NAT_P_GL_')
           {   $natglk = ($natglk + 1) }
       elsif 
           ($_ =~ 'NAT_P_OR_')
           {   $natork = ($natork + 1) }
       elsif 
           ($_ =~ 'NAT_P_OP_')
           {   $natopk = ($natopk + 1) }
       elsif 
           ($_ =~ 'NAT_P_CS_')
           {   $natcsk = ($natcsk + 1) }
       elsif 
           ($_ =~ 'NAT_P_CU_')
           {   $natcuk = ($natcuk + 1) }
       elsif 
           ($_ =~ 'NAT_P_SL_')
           {   $natslk = ($natslk + 1) }
       elsif
          ($_ =~ 'RBI_')
          {    $retk = ($retk + 1)} 
       elsif
          ($_ =~ 'RET_')
          {    $retk = ($retk + 1)} 
       elsif
          ($_ =~ 'SCM')
          {    $scmk = ($scmk + 1)} 
       else
           { }}

sub  resetk
 {
$natapk = 0;
$natedk = 0;
$natink = 0;
$natimk = 0;
$mantmk = 0;
$natmmk = 0;
$natpuk = 0;
$natslk = 0;
$natark = 0;
$nattlk = 0;
$natsdk = 0;
$natbik = 0;
$natibk = 0;
$natrbk = 0;
$natblk = 0;
$natcuk = 0;
$natcsk = 0;
$natork = 0;
$corfik = 0;
$coropk = 0;
$corork = 0;
$corblk = 0;
$yewik = 0;
$eurk = 0;
$ewmk = 0;
$misk = 0;
$totk = 0;
$nathrk = 0;
$natprk = 0;
$natslk = 0;
$natblk = 0;
$natopk = 0;
$natopk = 0;
$natglk = 0;
$retk = 0;
$natppk = 0;
$natpmk = 0;
$latk = 0;
$natshk = 0;
$coropk = 0;
$scmk = 0;
$watchk = 0;
$failk = 0;
$termk = 0;
$mank = 0;
$tabk = 0; }


sub dumpem {
         while ($tabk <= $#ctab)        
	 {   &countem;
	     $tabk = ($tabk + 1); }}

sub dumpem1 {
         while ($tabk <= $#ctab)        
	 {   &countem1;
	     ($tabk = $tabk + 1); }}
	     
sub countem1
              {
	  if ($ctab[$tabk] =~ 'akrsgmw1p')    
#           { print EMAIL "one $ctab[$tabk]  \n";  
	   {  &checksys;  }} 
	       
sub countem
	{ if ($ctab[$tabk] =~ 'akrsrv315')    
	   {  $akrlxautosysk = ($akrlxautosysk + 1);
	      $connectedk = ($connectedk + 1); }
	  elsif ($ctab[$tabk] =~ 'akrsrv315')    
	   {  $akrlxautosysk = ($akrlxautosysk + 1);
	      $connectedk = ($connectedk + 1); }
	  elsif ($ctab[$tabk] =~ 'ahqipa1')    
	   { $ahqipa1k = ($ahqipa1k + 1); 
	      $connectedk = ($connectedk + 1); } 
	  elsif ($ctab[$tabk] =~ 'ahqlpt0')    
	   { $ahqlpt0k = ($ahqlpt0k + 1); 
	      $connectedk = ($connectedk + 1); } 
	  elsif ($ctab[$tabk] =~ 'akrpcdmq')    
	   { $akrpcdmqk = ($akrpcdmqk + 1); 
	      &checksys;
	      $connectedk = ($connectedk + 1); } 
	  elsif ($ctab[$tabk] =~ 'akrsgmw1p')    
	   { $akrsgmw1pk = ($akrsgmw1pk + 1); 
#             print EMAIL "zero $ctab[$tabk]  \n";  
	      &checksys;
	      $connectedk = ($connectedk + 1); }
	  elsif ($ctab[$tabk] =~ 'akrgpodbna01')
	   { $akrgpodbna01k = ($akrgpodbna01k + 1); 
	      $connectedk = ($connectedk + 1); } 
          else
              { print EMAIL "$ctab[$tabk]  \n";  
	       $connectedk = ($connectedk + 1); } 
					    }
sub checksys 
 
    {  if ($ctab[$tabk] =~ 'SFILEIN')
           {$sfileink = ($sfileink + 1); }  
#              print EMAIL "$ctab[$tabk]  \n"; }  
#       elsif
#           ($ctab[$tabk] =~ '_W_')
#           {$watchk = ($watchk + 1) } 
       elsif 
          ($ctab[$tabk] =~ '_ID_')
           {   $misk = ($misk + 1) }
       elsif 
          ($ctab[$tabk] =~ '_IA_')
           {   $misk = ($misk + 1) }
       elsif 
          ($ctab[$tabk] =~ 'EWM')
           {   $ewmk = ($ewmk + 1) }
       elsif 
          ($ctab[$tabk] =~ 'EUR')
           {   $eurk = ($eurk + 1) }
       elsif 
          ($ctab[$tabk] =~ 'YEDW')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($ctab[$tabk] =~ 'YEWI')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($ctab[$tabk] =~ 'CNA_P_EW')
           {   $yewik = ($yewik + 1) }
       elsif 
          ($ctab[$tabk] =~ 'COR_P_EW')
           {   $yewik = ($yewik + 1) }
       elsif 
           ($ctab[$tabk] =~ 'MAN_P_TM')
           {   $mantmk = ($mantmk + 1) }
       elsif 
           ($ctab[$tabk] =~ 'MAN_P_EW')
           {   $mantmk = ($mantmk + 1) }
        elsif 
           ($ctab[$tabk] =~ 'MAN_')
           {   $mank = ($mank + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_FI_')
           {   $corfik = ($corfik + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_PU_')
           {   $corfik = ($corfik + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_TR_')
           {   $corfik = ($corfik + 1) }
          elsif 
           ($ctab[$tabk] =~ 'LAT')
           {   $latk = ($latk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_IB_')
           {   $natglk = ($natibk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_RB_')
           {   $natrbk = ($natrbk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_RB_')
           {   $natrbk = ($natrbk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_CU_')
           {   $natcuk = ($natcuk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_BI_')
           {   $natbik = ($natbik + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_CS_')
           {   $natcsk = ($natcsk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_OP_')
           {   $natopk = ($natopk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_OP_')
           {   $coropk = ($coropk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_BL_')
           {   $corblk = ($corblk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'COR_P_OR_')
           {   $corork = ($corork + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_GL_')
           {   $natglk = ($natglk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_OR_')
           {   $natork = ($natork + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_PM_')
           {   $natpmk = ($natpmk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_TL_')
           {   $nattlk = ($nattlk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_SD_')
           {   $nattlk = ($natsdk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_BL_')
           {   $natblk = ($natblk + 1) }
          elsif 
           ($ctab[$tabk] =~ 'NAT_P_AR_')
           {   $natark = ($natark + 1) }
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_AP_')
           {   $natapk = ($natapk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_ED_')
           {   $natedk = ($natedk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_HR_')
           {   $nathrk = ($nathrk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_MM_')
           {   $nathrk = ($natmmk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_PU_')
           {   $nathrk = ($natpuk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_PR_')
           {   $nathrk = ($natprk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_IN_')
           {   $natink = ($natink + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_IM_')
           {   $natimk = ($natimk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_PP_')
           {   $natppk = ($natppk + 1)}
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_SH_')
           {   $natshk = ($natshk + 1) }
         elsif 
           ($ctab[$tabk] =~ 'NAT_P_SL_')
           {   $natslk = ($natslk + 1) }
         elsif
          ($ctab[$tabk] =~ 'RBI_')
          {    $retk = ($retk + 1)} 
         elsif
          ($ctab[$tabk] =~ 'RET_')
          {    $retk = ($retk + 1)} 
         elsif
          ($ctab[$tabk] =~ 'SCM')
          {    $scmk = ($scmk + 1)} 
       else
           {   print EMAIL "error $ctab[$tabk]  \n"; } } 
	   }
