#!/bin/sh
#exec 2>/tmp/AUTO.DEBUG
#set -x
#
# Autosys autotrack dump of change information from Autosys database. 
# On exec, it sets the fromdate and todate to current date minus one day.
# Data is retrieved and then stored in $dumpfile.
# Script MUST run between midnight and noon to set dates correctly.
#
cd /home/ldautop
./autosysPRO.sh
#dayte=`TZ=EST17EDT date +"%D"`
dayte=`TZ=EST16 date +"%m"/"%d"/"%Y"`
#ayte=`TZ=EST17EDT,M3.2.0/3:00,M11.1.0/1:00 date +"%m"/"%d"/"%Y"`
echo date to work within $dayte
# Put a dash between year, month, day in filename.
fdayte=`TZ=EST16 date +"%Y-%m-%d"`
#dayte=`TZ=EST17EDT,M3.2.0/3:00,M11.1.0/1:00 date +"%Y-%m-%d"`
btyme=' 00:00:00'
etyme=' 23:59:59'
fromdate=$dayte$btyme
todate=$dayte$etyme
echo $fromdate $todate
dumpdir=$AUTOUSER/archive
dumpfile=$dumpdir/autotrack_dump_$fdayte.log
asterisk_line="***************************************************************************"
echo "$asterisk_line" > $dumpfile
echo "AutoSys change activity log from $fromdate to $todate" >> $dumpfile 
echo "Generated: `date`" >> $dumpfile
echo "Hostname: `hostname`" >> $dumpfile
echo "Filename: $dumpfile" >> $dumpfile
echo "$asterisk_line" >> $dumpfile
echo " " >> $dumpfile
autotrack -v -F  "$fromdate" -T "$todate" >> $dumpfile
exit

