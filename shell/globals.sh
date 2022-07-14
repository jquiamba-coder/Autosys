#!/usr/bin/perl -w	
$proded = 0;
open (LOG, '/home/ld874p1/globals.dat');
while (<LOG>) {
          if ($_ =~ 'proded') 
                  { $proded = ($proded + 1);  }
          elsif ($_ =~ 'no') 
                  { die "Global set to NO";  }


                      }		

close LOG;
