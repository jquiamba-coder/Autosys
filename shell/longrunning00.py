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

#open the file jobstat.txt as readable
with open("/opt/cascripts/shell/longrun_a.dat","r") as jobstat:

#create an output file runjob_output.txt
    with open("runjob_output.tsv", "w") as output_file:
        #create headers for each columns
        output_file.write("Job Name                                                         Start Date           Duration\n")
        output_file.write("-------------------------------------------------------------------------------------------------------\n")
        for line in jobstat:
            #search for lines with the string " RU " for running jobs
            if running_jobs in line:
                #search for lines with the datetime string value and put in a list and  convert them to datetime object
                matches = list(datefinder.find_dates(line))
                for date in matches:
                    #replace_date_format = datetime.strptime(date, '%m-%d-%y %H:%M:%S')
                    string1_to_replace = "-----"
                    string2_to_replace = " RU "
                    currentDate = datetime.now()
                    interval = "default"
                    duration = currentDate - date
                    longrun_threshold = timedelta(days=4)
                    if duration > longrun_threshold:
                        #remove microseconds from the duration
                        duration = str(duration).split(".")[0]
                        line = line.replace(string1_to_replace, duration)
                        line = line.replace(string2_to_replace, " ")
                        #search for pattern of the run number that ends with "/1" and remove them
                        pattern = re.sub(r"\d{7}\/\d", "", line)
                        # write the lines without the run number pattern
                        output_file.write(pattern)
                #count running, on hold and on ice jobs, included in "if running jobs in line" loop
                ru_job_count+=1
            #search for lines with the string " OH " for running jobs    
            if on_hold_jobs in line:
                oh_job_count+=1
            #search for lines with the string " OI " for running jobs
            if on_ice_jobs in line:
                oi_job_count+=1

#append the Total Counts
with open("runjob_output.tsv", "a+") as outfile2:
    outfile2.seek(0)
    outfile2.write("\n")
    #convert the total running , on hold and on ice jobs to a string
    outfile2.write("Total Running Jobs: " + str(ru_job_count))
    outfile2.write("\n")
    outfile2.write("Total On Hold Jobs: " + str(oh_job_count))
    outfile2.write("\n")
    outfile2.write("Total On Ice Jobs: " + str(oi_job_count))


print(f"Total Running Jobs: ", ru_job_count)
print(f"Total On Hold Jobs: ", oh_job_count)
print(f"Total On Ice Jobs: ", oi_job_count)


# open the runjob_output.txt as readable
#with open("runjob_output.txt", "r") as infile:
  #  data = infile.read()
# date finder finds datetime in the text file then computes for the duration of a job run and convert it to string
      #  string_to_replace = "-----"
      #  currDT = datetime.now()
      #  interval = "default"
      #  duration = currDT - date
      #  duration = str(duration).split(".")[0]
       # print('Run Duration: ', duration)

#with open ("runjob_output.txt", "r") as  

#with open('runjob_output.txt', 'w') as outfile:
 #   outfile.write(data)
#print("Text Replaced")

# Function to convert datetime object to string format
#def convert(dt_obj):
#    format = '%m/%d/%y %H:%M:%S'  # The format
#    datetime_str = datetime.strftime(dt_obj, format)
#    return datetime_str

