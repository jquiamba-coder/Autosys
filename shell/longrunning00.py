#!/bin/python3

########################################################################
# Script: longrunning00.py   Author: Julius Quiambao                   #
# Script looks for running jobs greater than 4 days.                   #
# Does many calculations to determine the runtime duration of a job.   #
#                                                                      #    
########################################################################

import dateutil
from dateutil import tz
import re
import os
import time
import datefinder
import subprocess
from datetime import datetime, timedelta

local_tz = tz.tzlocal()#define local timezone
current_datetime = datetime.now(local_tz)#set time zone to local

#variables to store jobs with running, On_hold and On_ice status
running_jobs = " RU "
on_hold_jobs = " OH "
on_ice_jobs = " OI "
oh_job_count = 0
oi_job_count = 0
ru_job_count = 0
save_path = '/var/autosys/con/int/working/'
file_name = "runjob_output.tsv"
CompleteFilePath = os.path.join(save_path, file_name)

#open the file longrun_a.dat as readable
with open("/var/autosys/con/int/working/longrun_a.dat","r") as jobstat:

#create an output file runjob_output.txt
    with open(CompleteFilePath, "w") as output_file:
        #create headers for each columns
        output_file.write("                                                                         Job Name                                                         Start Date/Time      Duration Days/Hours\n")
        output_file.write("----------------------------------------------------------------------------------------------------------\n")
        #set the flag to false initially
        long_running_job_found = False
        long_running_job = False #initialize the variable
        for line in jobstat:
            job_name = re.search(r'^\s*(\S+)\s+', line)
            if job_name and job_name.group(1).endswith("_REBATES"):
                continue
            # search for lines with the string " RU " for running jobs
            if running_jobs in line:
                # count running jobs
                ru_job_count += 1
                # search for lines with the datetime string value and put in a list and convert them to datetime object
                matches = list(datefinder.find_dates(line))
                for date in matches:
                    string1_to_replace = "-----"
                    string2_to_replace = " RU "
                    start_datetime = date
                    start_datetime = start_datetime.replace(tzinfo=local_tz)#set time zone to local
                    duration = current_datetime - start_datetime
                    if duration.days >= 4:
                        #set long running job to True. This is a checker to make sure every jobs we are getting are Valid long running jobs.
                        long_running_job = True
                        #convert the duration to string then remove seconds and microseconds
                        duration = ":".join(str(duration).split(":")[:2])
                        line = line.replace(string1_to_replace, duration)
                        line = line.replace(string2_to_replace, " ")
                        # search for pattern of the run number that ends with "/1" and remove them
                        pattern = re.sub(r"\d{7}/\d", "", line)
                        # write the lines without the run number pattern
                        output_file.write(pattern)
                        long_running_job_found = True
                    else:
                        #set long running job to False
                        long_running_job = False
                if not long_running_job:
                    continue
               # search for lines with the string " OH " for running jobs and count them
            if on_hold_jobs in line:
                    oh_job_count += 1
            # search for lines with the string " OI " for running jobs
            if on_ice_jobs in line:
                    oi_job_count += 1
        
        if not long_running_job_found:
            output_file.write("No Long Running jobs found\n")

# append the Total Counts to the start of the file
with open(CompleteFilePath, "r+") as outfile3:
    content = outfile3.read()
    outfile3.seek(0, 0)
    # convert the total running , on hold and on ice jobs to a string
    outfile3.write("Total Running Jobs: " + str(ru_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Hold Jobs: " + str(oh_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Ice Jobs: " + str(oi_job_count))
    outfile3.write("\n")
    outfile3.write("\n")
