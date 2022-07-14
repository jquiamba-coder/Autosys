#!/bin/bash
cd /opt/cascripts/backup/2021-10-01-akrlx323
stdCal=$("la_holidays")
jobs=$("insert_job:")
for stdCal in $(cat autosys.jobs.jil | grep "calendar: la_holidays" -A10); do
	echo "$stdCal is in $jobs"
done

