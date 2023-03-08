#!/bin/python3

import subprocess

# Define the number of days the job must have been running for.
DAYS_RUNNING = 4

# Run the autorep command to get a list of all jobs.
autorep_output = subprocess.check_output(['autorep', '-J', 'ALL'])

# Split the output into individual lines and loop through them.
for line in autorep_output.decode('utf-8').split('\n'):
    # Check if the line indicates a job that is currently running.
    if " RU " in line:
        # Use regular expressions to extract the job name and number of days running.
        import re
        match = re.search(r'(\S+)\s+\S+\s+(\d+)\s+days', line)
        if match:
            job_name = match.group(1)
            days_running = int(match.group(2))
            # If the job has been running for the specified number of days, force it to success.
            if days_running >= DAYS_RUNNING:
                print(f"Forcing job {job_name} to success.")
                subprocess.run(['sendevent', '-E', 'FORCE_STARTJOB', '-J', job_name, '-S', 'SUCCESS'])

