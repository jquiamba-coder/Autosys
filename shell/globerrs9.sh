#!/usr/bin/perl
########################################################################
# script: globerrs9.sh    Author: Julius Quiambao                      #
# Script sends the e-mails to the autosys admonstrators on jobs using  #
# threshold resources reports                                          #
########################################################################

open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:  Jobs with Threshold Resources\n\n";
print EMAIL "Message:  Jobs using threshold resources Report is available in the path: /opt/cascripts/shell/autosystools/autotool/reports/jobs_with_threshold_resources.jil";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL);
