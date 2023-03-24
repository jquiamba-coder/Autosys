#!/usr/bin/perl
########################################################################
# Script: longrun_b.sh    Author: Julius Quiambao                      #
# Script sends list of long running jobs to Autosys Administrators     #
########################################################################

$HOST="akrsrv317.na.goodyear.com";
$FILE="/opt/cascripts/shell/longrunning00.py";
$FLATFILE="/var/autosys/con/int/working/runjob_output.tsv";
$TIMEDATA = localtime();
open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: autosys_noreply\@goodyear.com\n";
print EMAIL "To: itsm_group_nausak_autosys\@goodyear.com,itsm_group_nausak_nat_otc_Support\@goodyear.com,itsm_group_ct_ptp_sap\@goodyear.com\n";
print EMAIL "Subject: Autosys Test - Long Running Jobs\n";
print EMAIL "***************************************\n";
print EMAIL "Environment - Test\n";
print EMAIL "Server - $HOST\n";
print EMAIL "Script - $FILE\n";
print EMAIL "Process - This script runs a daily report of long running jobs greater than or equal to 4 days\n\n";
print EMAIL "***************************************\n";
print EMAIL "$TIMEDATA\n\n";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL); 
close (FD);
