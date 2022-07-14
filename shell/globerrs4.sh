#!/usr/bin/perl
########################################################################
# Script: config12.sh    Author: Joe Funk                              #
# Script sends the e-mails to the autosys admonstrators on config      #
# file entries that are not used.                                      #
#                                                                      #
# Updated with local server paths                                      #                                   #
########################################################################
$FLATFILE="/var/autosys/prd/int/working/boxes01.dat";
open(FD,"<$FLATFILE") or die "$0: cannot read $FLATFILE: $!\n";
open(EMAIL,"|/usr/lib/sendmail -t") or die "0: cannot fork for sendmail:$!\n";
print EMAIL "From: $0\n";
print EMAIL "To: ahq.autosys.administrators\@goodyear.com\n";
print EMAIL "Subject:   Commands without Global Variables\n\n";
while ( <FD> )  { print EMAIL "$_"; }
close(EMAIL); 
close (FD);
