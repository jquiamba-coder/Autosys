#!/bin/python3
import os
import re
import glob
import shutil
from collections import defaultdict

# Set the directory path
directory_path = "/opt/CA/WorkloadAutomationAE/autouser.TST/archive/"

# Find the latest file in the directory
latest_file_path = max(glob.glob(directory_path + "autotrack_dump_*.log"), key=os.path.getctime)

# Set the output file path
output_file_path = "/var/autosys/con/int/working/autotrack_file.txt"

# Read the contents of the input file
with open(latest_file_path, 'r') as file:
    log_data =file.read()

# find header of autotrack log and include it in the output
start_header = "***************************************************************************\nAutoSys change activity log from"
end_header = "***************************************************************************"
start_index = log_data.index(start_header)
end_index = log_data.index(end_header, start_index + len(start_header)) + len(end_header)

# Extract the desired part from the file contents
desired_part = log_data[start_index:end_index]

# Write the desired part to the output file
with open(output_file_path, 'w') as output_file:
    output_file.write(desired_part)

# Split the content into blocks
blocks = log_data.split(':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::')

if blocks[0].strip() == '':
    blocks = blocks[2:]

# Function to extract user IDs from a block
def extract_user_ids(block):
    lines = block.strip().split('\n')
    user_ids = []
    for i, line in enumerate(lines):
        line = line.strip()
        if re.match(r'^\d{2}/\d{2}/\d{4}', line):
            user_id = lines[i - 1].strip()
            user_ids.append(user_id)
    return user_ids

# Function to check if a block contains "CAUAJM_I_50152 Sendevent issued"
def contains_sendevent(block):
    return 'CAUAJM_I_50152 Sendevent issued' in block

# Function to check if a block contains "CAUAJM_I_50191 Job definition change"
def contains_job_change(block):
    return 'CAUAJM_I_50191 Job definition change' in block


# Function to count job definitions (insert_job, update_job, delete_job) in a block
def count_job_definitions(block):
    job_definitions = ['insert_job', 'update_job', 'delete_job']
    counts = defaultdict(int)

    lines = block.strip().split('\n')
    for line in lines:
        line = line.strip()
        for job_definition in job_definitions:
            if line.startswith(job_definition):
                counts[job_definition] += 1

    return dict(counts)

# Dictionary to store the results
results = {}

# Process each block
for block in blocks:
    user_ids = extract_user_ids(block)

    for user_id in user_ids:
        if user_id not in results:
            results[user_id] = {
                'contains_sendevent': False,
                'sendevent_count': 0,
                'contains_job_change': False,
                'job_definitions_count': {
                    'insert_job': 0,
                    'update_job': 0,
                    'delete_job': 0
                }
            }

        if contains_sendevent(block):
            results[user_id]['contains_sendevent'] = True
            results[user_id]['sendevent_count'] += 1

        if contains_job_change(block):
            results[user_id]['contains_job_change'] = True
            job_definitions_count = count_job_definitions(block)
            for job_definition, count in job_definitions_count.items():
                results[user_id]['job_definitions_count'][job_definition] += count

# append to file
with open(output_file_path, 'a') as file:
    for user_id, data in results.items():
        file.write('\nUser ID: ' + user_id + '\n')
        file.write('Contains "CAUAJM_I_50152 Sendevent issued": ' + str(data['contains_sendevent']) + '\n')
        file.write('Sendevent Count: ' + str(data['sendevent_count']) + '\n')
        file.write('Contains "CAUAJM_I_50191 Job definition change": ' + str(data['contains_job_change']) + '\n')
        file.write('Job Definitions Count: ' + str(data['job_definitions_count']) + '\n')
        file.write('\n')

# Print the sample output
for user_id, data in results.items():
    print('User ID:', user_id)
    print('Contains "CAUAJM_I_50152 Sendevent issued":', data['contains_sendevent'])
    print('Sendevent Count:', data['sendevent_count'])
    print('Contains "CAUAJM_I_50191 Job definition change":', data['contains_job_change'])
    print('Job Definitions Count:', data['job_definitions_count'])
    print()
