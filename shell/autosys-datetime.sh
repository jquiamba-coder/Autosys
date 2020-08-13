#!/bin/bash
#
# AutoSys executed script to run simple commands and log results to validate the agent is running and able execute jobs
# Neil Komorek 2019/11/12
#
 

# Get hostname, date and time
NOW=$(date +"%Y-%m-%d %T")
HOST=`hostname`

# AutoSys will direct standard out to a job log file
echo "$NOW $HOST AutoSys connectivity test"

