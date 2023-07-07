#!/bin/python3

########################################################################
# Script: gy.autosys.casrvcstat.py   Author: Julius Quiambao           #
# Script to creates an incident if CA Services stops running           #
#                                                                      #
#                                                                      #
########################################################################

import re
import os
import json
import requests

# Initialize a dictionary to store the component name for each status
component_status = {}

# Set the request parameters
url = 'https://goodyeardev.service-now.com/api/now/table/incident'

# Set API credentials
user = 'LDSNASD'
pwd = 'WhatIsJobScheduling4OnDev'

# Set proper headers
headers = {"Content-Type":"application/json","Accept":"application/json"}

# Read the file
with open("/var/autosys/con/int/working/ca_services_stat_report.txt","r") as caservices:
    lines = caservices.readlines()

# Find the starting index of the component and status data
start_index = 0

for i, line in enumerate(lines):
    if 'Component Name' in line:
        start_index = i + 2  # Skip the header line and the dashed line
        break

# Iterate over the lines starting from the calculated index
for line in lines[start_index:]:
    # Extract the component name and status using regex patterns
    matches = re.match(r'^(.*?)\s+(\d+)\s+(\w+)$', line)
    if matches:
        component_name = matches.group(1)
        status = matches.group(3)

        # Store the component status for each component name
        component_status[component_name] = status

        if status != 'running':
            # Create an incident in ServiceNow
            incident_data = {
                    "caller_id": "LDSNASD",
                    "short_description": f"CA Services Status Failed: {str(component_status)}",
                    "assignment_group": "NAUSAK_Autosys",
                    "u_preferred_contact_method_caller": "Email",
                    "u_preferred_contact_method_impacted_user": "Email",
                    "impact": "3",
                    "urgency": "3",
                    "category": "Applications",
                    "subcategory": "Error",
                    "cmdb_ci": "Autosys - Job Scheduling",
                    "description": f"Status found " + str(status) + " for CA Services component " + str(component_status)
                    }

            # Do the HTTP request
            response = requests.post(url, auth=(user, pwd), headers=headers, data = json.dumps(incident_data))

            # Check for HTTP response status code to make sure that incident is created succesfully
            if response.status_code == 201:
                data = response.json()
                incident_number = data.get('result', {}).get('number')
                print('Incident created successfully. Incident Number:', incident_number)

            else:
                print('Failed to create incident:', response.text)

# Print the component name for each status
for component_name, status  in component_status.items():
    print(f"Component Name: {component_name}, Status: {status}")

