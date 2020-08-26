#!/bin/bash
#
##################################
# Scrpt to duplicate all daily jil's and scp them to
# the backup server akrnetbkpna1 163.243.52.180
#
##################################


### Set variables ###
NOW=$(date +"%Y-%m-%d")
JIL_HOME=/opt/CA/WorkloadAutomationAE/autouser.PRD
BACKUP_DIR=/opt/cascripts/backup

cd $BACKUP_DIR
mkdir $NOW-$HOSTNAME

cp $JIL_HOME/*.jil $BACKUP_DIR/$NOW-$HOSTNAME
tar -zcvf $NOW-$HOSTNAME.tar.gz $NOW-$HOSTNAME

# Copy file to backup server
scp $NOW-$HOSTNAME.tar.gz 163.243.52.180:/d:/sftp/autosys_backup/$HOSTNAME/$NOW-$HOSTNAME.tar.gz

# Cleanup local files
# find . -mtime +4 -delete

