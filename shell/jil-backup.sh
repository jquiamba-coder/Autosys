#!/bin/bash
#
##################################
# This script automates the process of backing up various Autosys resources, including jobs, 
# machines, monitoring and browser definitions, global variables, calendars, and email templates.
# It organizes the backup files into a directory structure based on the current date and hostname,
# compresses them into an archive, and then copies the archive to a backup server. 
# Duplicate all daily jil's and scp them to the backup server akrnetbkpna1 163.243.52.180
# Delete older backup files.
# Updated 5/22/2023
##################################


# Set variables 
# Capture date and destination path
NOW=$(date +"%Y-%m-%d")
BACKUP_DIR=/opt/cascripts/backup

# Create new folder for the backups
cd $BACKUP_DIR
mkdir $NOW-$HOSTNAME
cd $NOW-$HOSTNAME

# Backup resources jil format
autorep -V ALL -q > autosys.resources.jil

# Backup jobs jil format
autorep -J ALL -q > autosys.jobs.jil

# Backup of jobs status
autorep -J ALL -s > autosys.jobstat.txt

# Copy daily back up of autosys job status for the autopoller script to read
cp autosys.jobstat.txt /opt/cascript/shell/autosystools/autotool/reports/autosys.jobstat.$(date -d "yesterday" +%Y-%m-%d).txt

# Make a copy for the autotool
cp -f autosys.jobs.jil /opt/cascripts/shell/autosystools/autotool/export/autorepall.txt
cp -f autosys.jobstat.txt /opt/cascripts/shell/autosystools/autotool/export/

# Make a list of all unique service desk attributes from all jobs
cat autosys.jobs.jil | grep "svcdesk_attr: " | sort -u | sed -e 's/^[[:space:]]*//' > /opt/cascripts/shell/autosystools/autotool/reports/svcdesk_attr.list

# Make a list of jobs not using threshold resources
cat autosys.jobs.jil | grep "insert_job: " -B 2 -A 12 | grep -v -e "resources: (thr_" -e "notification_emailaddress:" -e "condition:" -e "date_conditions:" -e "permission:" -e "owner:" -e "machine:" -e "profile:" -e "alarm_if_fail:" -e "std_err_file:" -e "std_out_file:" -e "description:" -e "command:" -e "box_name:" -e "run_calendar:" -e "start_times:" -e "application:" -e "------" -e "--" -e "days_of_week:" -e "start_mins:" -e "timezone:" -e "term_run_time:" -e "box_terminator:" -e "send_notification:" -e "job_terminator:" -e "svcdesk_attr:" -e "box_success:" -e "watch_file:" -e "max_run_alarm:" -e "run_window:" -e "n_retrys:" -e "notification_msg:" | grep "job_type: BOX" | awk '{print$2}' > /opt/cascripts/shell/autosystools/autotool/reports/jobs_without_threshold_resources.list

# Backup machines jil format
autorep -M ALL -q > autosys.mach.jil

# Backup monitoring and browser definitions jil format
monbro -N ALL -q > autosys.monbro.jil

# Backup global variables jil format
autorep -G ALL > autosys.globals.jil

# Backup calendars txt, restore with #autocal_asc -I filename.txt
# Standard calendars
autocal_asc -E cals-std.txt -s ALL
# Extended calendars
autocal_asc -E cals-ext.txt -e ALL
# Cycles
autocal_asc -E cycles.txt -c ALL

# Email templates
autorep -z ALL -f .  -a

# Create archive
cd $BACKUP_DIR
tar -zcvf $NOW-$HOSTNAME.tar.gz $NOW-$HOSTNAME

# Copy file to backup server
scp $NOW-$HOSTNAME.tar.gz 163.243.52.180:/d:/sftp/autosys_backup/$HOSTNAME/$NOW-$HOSTNAME.tar.gz

# Cleanup local files
find . -mtime +5 -delete

