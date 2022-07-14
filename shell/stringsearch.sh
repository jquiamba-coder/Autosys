#!/usr/bin/perl

$ADM = 0;
$OPS = 0;
$boxsw = ' ';

open (OUTFILE, ">//var/nat/prd/int/working/comm0test.dat") or die "can't open the filename $!\n";
open (LOG, '//opt/CA/WorkloadAutomationAE/autouser.PRD/autosys.jobs.jil');

while ($line  = <LOG>) {
        if ($line =~ /insert_job: ADM_/) {
	print OUTFILE "This is an ADM Job - $line\n";
	$ADM = ($ADM + 1);
	
        }
	elsif ($line =~ /insert_job: OPS_/) {
	print OUTFILE "This is an OPS Job - $line\n";
	$OPS = ($OPS +1);
	}
}
print OUTFILE "Total ADM jobs is - $ADM\n";
print OUTFILE "Total OPS jobs is - $OPS\n";
close LOG;
close OUTFILE;

