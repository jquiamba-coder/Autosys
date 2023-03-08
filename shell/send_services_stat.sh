#!/usr/bin/perl
########################################################################
# Script: ca_services_stat.sh    Author: Julius Quiambao               #
# Script sends the e-mails to the autosys admonstrators on Autosys     #
# Services Status                                                      #
#                                                                      #
########################################################################
$HOST = "akrsrv317.na.goodyear.com";
$FILE = "/opt/cascripts/shell/ca_services_stat.sh";
$FLATFILE="/var/autosys/con/int/working/ca_services_stat_report.txt";
open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: autosys_noreply\@goodyear.com\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:   CA Services Status Report\n\n";
print EMAIL "***************************************\n ";
print EMAIL "Environment - Test\n";
print EMAIL "Server - $HOST\n";
print EMAIL "Script - $FILE\n";
print EMAIL "Process - This script runs to check if Autosys Services are running\n\n";
print EMAIL "***************************************\n ";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);
close (FD);
