#!/bin/bash
#
# AutoSys executed script to run simple commands and log results to validate the agent is running and able execute jobs
# Neil Komorek 2019/11/12
#

# Be sure to run in home directory
cd $HOME

# Get hostname, date and time
NOW=$(date +"%Y-%m-%d %T")
HOST=`hostname`

# AutoSys will direct standard out to a job log file
echo "$NOW $HOST AutoSys connectivity test"

# Trim log file to 1000 lines
sed -i -e :a -e '$q;N;1000,$D;ba' ADM_P_I$_C_Z_AGENT_*

