#!/bin/python3

########################################################################
# Script: longrunning00.py   Author: Julius Quiambao                   #
# Script looks for running jobs greater than 4 days.                   #
# Does many calculations to determine the runtime duration of a job.   #
#                                                                      #    
########################################################################

import os
import time
import subprocess
from datetime import datetime, timedelta

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
        output_file.write("                                                                                                                                                                  Job Name                               Start Date/Time      Duration Days/Hours\n")
        output_file.write("-------------------------------------------------------------------------------------\n")
        #set long running job initially to FALSE
        long_running_job_found = False
        #iterate thru the input file
        for line in jobstat:
            # search for lines with the string " OH " for running jobs and count them
            if on_hold_jobs in line:
                    oh_job_count += 1
            # search for lines with the string " OI " for running jobs
            if on_ice_jobs in line:
                    oi_job_count += 1            
            # search for lines with the string " RU " for running jobs
            if running_jobs in line:
                # count running jobs
                ru_job_count += 1
                # Split the line into fields
                fields = line.split()
                # Get the job name
                job_name = fields[0]
                # Get the start time
                start_time_str = fields[1] + " " + fields[2]
                start_time = datetime.strptime(start_time_str, "%m/%d/%Y %H:%M:%S")
                duration = datetime.now() - start_time
                if duration.days >= 4:
                    #convert the duration to string then remove seconds and microseconds
                    duration = ":".join(str(duration).split(":")[:2])
                    # write the output
                    output_file.write((job_name) + " "*(38-len(job_name)) + str(start_time) + " "*(27-len(str(start_time))) + str(duration))
                    output_file.write("\n")
                    long_running_job_found = True
                elif duration.days >= 7:
                    print(f"Killing job {job_name}...completed")
                    subprocess.run(['sendevent', '-E', 'KILLJOB', '-J', job_name])

        if not long_running_job_found:
            output_file.write("No Long Running jobs found\n")

# append the Total Counts to the start of the file
with open(CompleteFilePath, "r+") as outfile3:
    content = outfile3.read()
    outfile3.seek(0, 0)
    # convert the total running , on hold and on ice jobs to a string
    outfile3.write("Long Running Jobs Report")
    outfile3.write("\n")
    outfile3.write("\n")
    outfile3.write("Total Running Jobs: " + str(ru_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Hold Jobs: " + str(oh_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Ice Jobs: " + str(oi_job_count))
    outfile3.write("\n")
    outfile3.write("\n")
    outfile3.write("\n")
    outfile3.write("Note: Long Running Jobs 7 days or higher will be terminated!")
    outfile3.write("\n")
    outfile3.write("\n")
