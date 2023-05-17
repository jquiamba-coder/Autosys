#!/usr/bin/perl
########################################################################
# Script: sysutilsend.sh    Author: Julius Quiambao                    #
# Script sends System Utility Information of the Server                #
########################################################################

$FILE="/opt/cascripts/shell/autoutil.py\n";
$FLATFILE="/var/autosys/con/int/working/sysutil_info.dat";
$TIMEDATA = localtime();
open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: autosys_noreply\@goodyear.com\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject: System Utility Information\n";
print EMAIL "***************************************\n";
print EMAIL "Environment - Test\n";
print EMAIL "Script - $FILE\n";
print EMAIL "Process - Sends System Health Checks\n";
print EMAIL "***************************************\n";
print EMAIL "$TIMEDATA";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);
close (FD);

