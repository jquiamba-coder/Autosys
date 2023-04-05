#!/bin/python3

########################################################################
# Script: longrun_servicenow.py   Author: Julius Quiambao              #
# Script to creates an incident for long running jobs                  #
#                                                                      #
#                                                                      #
########################################################################

import re
import os
import json
import requests

# Set the request parameters
url = 'https://goodyeardev.service-now.com/api/now/table/incident'

# Eg. User name="admin", Password="admin" for this code sample.
user = 'LDSNASD'
pwd = 'WhatIsJobScheduling4OnDev'

# Set proper headers
headers = {"Content-Type":"application/json","Accept":"application/json"}


with open("/var/autosys/con/int/working/runjob_output.tsv","r") as longrunning:
    lines = longrunning.readlines()
    for line in lines:
        if re.match(r'^\S+_\S+', line):
            # Extract job name and duration from line
            job_name = line.split()[0]
            duration = re.search(r'\d+ days, \d+:\d+', line).group(0)            
            #Setup payload
            payload = {
                "caller_id": "LDSNASD",
                "short_description": "Long Running Job: " + job_name,
                "assignment_group": "GLOBAL_SNO_L1",
                "u_preferred_contact_method_caller": "Email",
                "u_preferred_contact_method_impacted_user": "Email",
                "impact": "3",
                "urgency": "3",
                "category": "Applications",
                "subcategory": "Job Issue",
                "cmdb_ci": "Autosys - Job Scheduling",
                "description": f"The job " + job_name + " with a duration of " + duration + " has been running for an extended period of time, please check the phone file and assign this incident to the Service Now Assignment group of the Job Owner\n\n PhoneFile: https://goodyearcorp.sharepoint.com/sites/GLITInfra/OnCall/PhoneFile/SitePages/Home.aspx"                
            }

            # Do the HTTP request
            response = requests.post(url, auth=(user, pwd), headers=headers, data = json.dumps(payload))

            # Check for HTTP codes other than 201
            if response.status_code != 201: 
                print('Status:', response.status_code, 'Headers:', response.headers, 'Error Response:',response.json())
        
            else:
                print("Incident created for", job_name)
                data = response.json()
                print(data)
