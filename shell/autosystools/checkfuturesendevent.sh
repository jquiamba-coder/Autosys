#!/bin/bash
 cat ./import/jobs_list | while read line
        do
                jobname="$line"
                autorep -j $jobname -d -L0 >>./export/jobstatus.jil
                echo $line Export successful
        done

