#!/bin/python3

import json
import csv

# File IO
file_input = '/opt/cascripts/shell/autosystools/autotool/export/autorepall.txt'
file_output_tsv = '/opt/cascripts/shell/autosystools/autotool/reports/autosys.jobs.jil.tsv'
file_output_json = '/opt/cascripts/shell/autosystools/autotool/reports/autosys.jobs.jil.json'

# Dictionaries
dict_job_data = dict()

# Lists
list_autosys_fields = []
list_autosys_fields_custom = ['_name', '_type', '_ctypes', '_cc_and', '_cc_or', '_cc_lb']
list_autosys_types = []
list_condition_types = []


# Open Jil file
data_jil = open(file_input, "r")

# Counters
count_insert = 0
count_job = 0
count_box = 0
count_condition_and = 0
count_condition_or = 0
count_condition_lb = 0

active_job = ''

# Loop through Jil to Get Fields and types
for line in data_jil:

    # Split on Jil Delimiter
    if ': ' in line:
        line_split_field = line.split(': ')
        line_split_data = line.split(': ', 1)
        line_field = line_split_field[0].strip()
        line_data: str = line_split_data[1].strip()

        # Get Condition Type
        if line_field == 'condition':
            list_condition_types = []
            count_condition_and = line_data.count('&')
            count_condition_or = line_data.count('|')
            count_condition_lb = line_data.count(',')
            # Loop through alphabet to avoid hard coding condition types
            for i in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
                      't', 'u', 'v', 'w', 'x', 'y', 'z', ]:
                if f'{i}(' in line_data:
                    list_condition_types += i
            dict_job_data[active_job]['_ctypes'] = list_condition_types
            dict_job_data[active_job]['_cc_and'] = count_condition_and
            dict_job_data[active_job]['_cc_or'] = count_condition_or
            dict_job_data[active_job]['_cc_lb'] = count_condition_lb

        # Read Insert Job + Process
        if line_field == 'insert_job':
            count_insert += 1
            #  Get Job Name
            line_job = line_split_field[1].strip()
            line_job = line_job.split(" ", 1)
            line_job = line_job[0]
            active_job = line_job

            # Get Job Type
            line_type = line_split_field[2].strip()
            list_autosys_types.append(line_type)

            # Count boxes and non-boxes
            if line_type == 'BOX':
                count_box += 1
            else:
                count_job += 1

        # Create Dictionary if not already exists
        if active_job != '':
            if active_job in dict_job_data.keys():
                # print(active_job)
                dict_job_data[active_job][line_field] = {}
                dict_job_data[active_job][line_field] = line_data
            else:
                dict_job_data[active_job] = {}
                dict_job_data[active_job]['_name'] = active_job
                dict_job_data[active_job]['_type'] = line_type

        list_autosys_fields.append(line_field)

# AutoSys + Custom Fields
list_autosys_fields_unique = set(list_autosys_fields)
list_autosys_types_unique = set(list_autosys_types)

# Output Report
print(f"\n  AutoSys Insert: {count_insert}")
print(f"   AutoSys Boxes: {count_box}")
print(f"    AutoSys Jobs: {count_job}")

print("\nAutoSys Types:")
for item in list_autosys_types_unique:
    print(f"    {item}")

print("\nAutoSys Fields:")
for item in list_autosys_fields_unique:
    print(f"    {item}")

print("\nCustom Fields:")
for item in list_autosys_fields_custom:
    print(f"    {item}")

# Write JSON File & Close
print("\nCreating JSON...")
with open(file_output_json, 'w', encoding='utf-8') as f:
    json.dump(dict_job_data, f, ensure_ascii=False, indent=2)
f.close()

# Close Jil file
data_jil.close()

# Convert JSON file to CSV & close
new_file_output_tsv = open(file_output_tsv, 'w')
csv_writer = csv.writer(new_file_output_tsv)

# Combine discovered fields with custom fields
combined_fields = list_autosys_fields_custom
combined_fields += list_autosys_fields_unique

with open(file_output_json) as json_file:
    json_data = json.load(json_file)

# create tab delimited file and print header
print("\nCreating CSV...")
w = csv.DictWriter(new_file_output_tsv, fieldnames=combined_fields, delimiter='\t')
w.writeheader()
for key, val in sorted(json_data.items()):
    row = {'_name': key}
    assert isinstance(val, object)
    row.update(val)
    w.writerow(row)
new_file_output_tsv.close()
json_file.close()
