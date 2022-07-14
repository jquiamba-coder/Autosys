#/bin/bash
#######################################################################
# Author: David Uyek                                                  #
# Date: 06/3/2021                                                     #
# v1.0                                                                #
# Script to check if a job has started today or not. And if so, check #
# if that job is currently running                                    #
#######################################################################

#######################################################################################
# We check the 5th column because when the job is running there is no end time so the #
# awk is missing the time in the last run column                                      #
#######################################################################################
check_job_status=`autorep -j $1 -s -l0 | awk 'FNR == 4 {print $5}'`

#########################################
# Gather the current month day and year #
#########################################
current_date=`date +%m\/%d\/%Y`
current_job_day=`autorep -j $1 -s -l0 | awk 'FNR == 4 {print $2}'`

#######################################################################################
# We check the last start time of the argumented job and compair it to the current date #
#######################################################################################
if [ $current_date == $current_job_day ]
then
        ###################################################################
        # If the jobs last start time is today, check to see if the       #
        # current state of the current job is running                     #
        ###################################################################
        if [ $check_job_status = RU ]
        then
                echo "Job $1 is still running!"
                echo exit 1
                exit 1
        else
                echo "Job $1 is not running."
                echo exit 0
                exit 0
        fi
else
        echo "$1 HASN'T RAN YET"
        echo exit 1
        exit 1
fi

