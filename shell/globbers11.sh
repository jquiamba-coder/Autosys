#!/usr/bin/perl
########################################################################
# script: globerrs10.sh    Author: Julius Quiambao                     #
# Script sends the e-mails to the autosys admonstrators on jobs not    #
# using threshold resources reports                                    #
#                                                                      #
########################################################################

open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:  Jobs without Threshold Resources\n\n";
print EMAIL "Message:  Jobs not using threshold resources Report is available in the path: /opt/cascripts/shell/autosystools/autotool/reports/jobs_without_threshold_resource";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);

