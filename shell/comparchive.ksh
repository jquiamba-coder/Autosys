#!/bin/sh
#exec 2>/tmp/AUTO.DEBUG
#set -x
#
# Compress any uncompressed logfiles in $AUTOUSER/archive that are not
# zero-byte files.  Match filenames to avoid normal error message from 
# attempting to compress .Z files (which are already compressed). 
#
# No longer correct paths 2022-01-22 (Neil Komorek)
#cd /opt/autosys
#. autosysPRD.sh


archdir=$AUTOUSER/archive

# Compress uncompressed audit logs.  
compfile=$archdir/archived_audit.PRO.*.*.????
for i in $compfile
   do
      if [ -s $i ]; then
         echo compressing $i
         compress $i
      fi
   done

# Compress uncompressed event logs.  
compfile=$archdir/archived_events.PRO.*.*.????
for i in $compfile
   do
      if [ -s $i ]; then
         echo compressing $i
         compress $i
      fi
   done

# Compress uncompressed job run logs.  
compfile=$archdir/archived_job_runs.PRO.*.*.????
for i in $compfile
   do
      if [ -s $i ]; then
         echo compressing $i
         compress $i
      fi
   done

# Compress uncompressed autotrack logs.  
compfile=$archdir/autotrack_dump_*.log
for i in $compfile
   do
      if [ -s $i ]; then
         echo compressing $i
         compress $i
      fi
   done

# Compress uncompressed autotrack logs.  
compfile=$archdir/event_demon.PRO.bk.????????????
for i in $compfile
   do
      if [ -s $i ]; then
         echo compressing $i
         compress $i
      fi
   done

exit

