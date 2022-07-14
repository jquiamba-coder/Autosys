#!/usr/bin/perl
########################################################################
# script: globerrs6.sh    Author: Julius Quiambao                      #
# Script sends the e-mails to the autosys admonstrators on weekly      #
# jobstatus reports                                                    #
########################################################################
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:  Weekly Job Status Reports\n\n";
print EMAIL "Message:  The Job Status Report is available in the path: /opt/cascripts/shell/autosystools/autotool/reports/jobstat.csv";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);
