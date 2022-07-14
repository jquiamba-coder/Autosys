#!/bin/sh
msg=$2
lotus_notes_group=$1
echo first parameter: $1
echo $lotus_notes_group
  /usr/sbin/sendmail -t <<END_OF_TEXT
Subject: Autosys message $2  (eom)
To: "$lotus_notes_group"@goodyear 
From: Autosys User 

         $msg 



END_OF_TEXT

exit 0
