#!/bin/bash
#Author - David Uyek 2018
#This is a modified version of usertool.sh. This one sends all prefixes
#as one email
#This script is to allow users to pull their own inert job reports
#A full autorep will be stored daily at 3am, the greped upon afterwards to 
#save users time.
#v0.1 - added variable to allow custom date ranges
#v0.2 - updated the way this scrip searches the autorepall log so it spits
#things out sequentially. Once it emails the list it cleans up after itself

#============================================================================
#Function for inertjobs() greps the autorep -s to exclude the last however 
#many days as set in argument 2
#============================================================================
greptherep()
{
var="1"
for (( i = 0; i <= $2; i++ ))
do
var="`date -d "-$i days" +%m/%d/%Y`|"
var2="$var2$var"
done

grep -Ev "`date +%m/%d/%Y`|$var2`date -d "-$2 days" +%m/%d/%Y`" ./export/autorepall.txt >./export/autorepalltrimmed.txt

#===========================================================================================
#The below looks if there is a argument with -z, and if there is it runs the following greps
#===========================================================================================
grep "$3" ./export/autorepalltrimmed.txt>./export/autorepallinorder.txt
[ ! -z "$4" ] && grep "$4" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt
[ ! -z "$5" ] && grep "$5" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt
[ ! -z "$6" ] && grep "$6" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt
[ ! -z "$7" ] && grep "$7" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt
[ ! -z "$8" ] && grep "$8" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt
[ ! -z "$9" ] && grep "$9" ./export/autorepalltrimmed.txt>>./export/autorepallinorder.txt

cat ./export/autorepallinorder.txt 2>&1| mail -s "Inactive jobs for $3 $4 $5 $6 $7 $8 $9" $1
rm ./export/autorepalltrimmed.txt
rm ./export/autorepallinorder.txt

}
#=========================================================
#This script uses arguments to allow the user of the same
#script to pull different jobs for users via autosys jobs
#and send them in a full batch to an address (arg1)
#argument 1 = email address to send mail to
#argument 2 = number of days back to omit
#argument 3 - x = prefixes to set to grep.
#=========================================================
greptherep $1 $2 $3 $4 $5 $6 $7 $8 $9
