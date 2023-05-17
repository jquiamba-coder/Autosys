#!/bin/python3

import datetime

job_failures = {}
log_directory = "/opt/cascripts/shell/autosystools/autotool/reports/"
job_failure = " FA "

# Iterate over log files for the past 7 days
for i in range(7):
    # Determine the date of the log file to parse
    date = datetime.date.today() - datetime.timedelta(days=i)
    jobstatfile = f"{log_directory}autosys.jobstat.{date}.txt"
    # Open the log file and parse job statuses
    with open(jobstatfile, "r") as f:
        for line in f:
            if job_failure in line:
                job_status = line.split(" FA ")[1].strip()
                job_name = line.split(" ")[0].strip()
                if job_name not in job_failures:
                    job_failures[job_name] = 1
                else:
                    job_failures[job_name] += 1

output_file ="/opt/cascripts/shell/autosystools/autotool/reports/autopoll_results.txt"
with open(output_file,"w") as f: 
    for job, num_failures in job_failures.items(): 
        if num_failures >= 3:
            output_string = f"{job} has failed {num_failures} times in the past 7 days.\n"
            print(output_string,end="")
            f.write(output_string)


