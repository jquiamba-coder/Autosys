#!/bin/python3

import re
import os
import time
import datefinder
from datetime import datetime, timedelta

#variables to store jobs with running, On_hold and On_ice status
running_jobs = " RU "
on_hold_jobs = " OH "
on_ice_jobs = " OI "
oh_job_count = 0
oi_job_count = 0
ru_job_count = 0
save_path = '/var/autosys/prd/int/working/'
file_name = "runjob_output.tsv"
CompleteFilePath = os.path.join(save_path, file_name)

#open the file jobstat.txt as readable
with open("/var/autosys/prd/int/working/longrun_a.dat","r") as jobstat:

#create an output file runjob_output.txt
    with open(CompleteFilePath, "w") as output_file:
        #create headers for each columns
        output_file.write("                                                                         Job Name                                                         Start Date/Time      Duration Days/Hours\n")
        output_file.write("------------------------------------------------------------------------------------------------------------------------------------------\n")
        for line in jobstat:
            #search for lines with the string " RU " for running jobs
            if running_jobs in line:
                #count running jobs
                ru_job_count+=1
                #search for lines with the datetime string value and put in a list and  convert them to datetime object
                matches = list(datefinder.find_dates(line))
                for date in matches:
                    #replace_date_format = datetime.strptime(date, '%m-%d-%y %H:%M:%S')
                    string1_to_replace = "-----"
                    string2_to_replace = " RU "
                    currentDate = datetime.now()
                    interval = "default"
                    duration = currentDate - date
                    if duration.days > 4:
                        #convert the duration to string then remove microseconds
                        duration = str(duration).split(".")[0]
                        line = line.replace(string1_to_replace, duration)
                        line = line.replace(string2_to_replace, " ")
                        #search for pattern of the run number that ends with "/1" and remove them
                        pattern = re.sub(r"\d{8}/\d", "", line)
                        # write the lines without the run number pattern
                        output_file.write(pattern)
                    else:
                        print("No long running jobs")
            else:
                print("Not running: ",line)
            #search for lines with the string " OH " for On Hold jobs and count   
            if on_hold_jobs in line:
                oh_job_count+=1
            #search for lines with the string " OI " for On Ice jobs and count
            if on_ice_jobs in line:
                oi_job_count+=1

#exclude unwanted jobs this is a temporary solution for the final output
with open(CompleteFilePath, "r") as outfile2:
    lines = outfile2.readlines()

with open(CompleteFilePath, "w") as outfile2:
    for line in lines:
        if not line.startswith('NAT_P_'):
            outfile2.write(line)

#append the Total Counts to the start of the file
with open(CompleteFilePath, "r+") as outfile3:
    content = outfile3.read()
    outfile3.seek(0, 0)
    #convert the total running , on hold and on ice jobs to a string
    outfile3.write("Total Running Jobs: " + str(ru_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Hold Jobs: " + str(oh_job_count))
    outfile3.write("\n")
    outfile3.write("Total On Ice Jobs: " + str(oi_job_count))
    outfile3.write("\n")
    outfile3.write("\n")
