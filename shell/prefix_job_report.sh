#!/bin/bash

BACKUP_DIR=/opt/CA/WorkloadAutomationAE/autouser.PRO
cd $BACKUP_DIR

grep "insert_job:" autosys.jobs.jil | awk '{print$2}' | awk -F "_" '{print$1}' | sort -u > /opt/cascripts/shell/autosystools/autotool/export/current_prefix_jobs.txt
