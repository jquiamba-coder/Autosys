#!/bin/bash
toolversion="v1.1.21"
#v1.1.21 - Added a function that will terminate the jobs or force them to success
#v1.1.20 - Added a function that will output standard, extended calendars and cycles definition
#v1.1.19 - Added a function that will grep all job prefixes from the autorepall.txt
#v1.1.18 - Added a function that will Autorep all job summary report and a function to autorep job status of specific jobs from jobs_list in the import directory
#v1.1.17 - Added function to count  Whitelisted Jobs that did not run for two years or more in the Jobs Prefix 730 days count

#v1.1.16 - Added function to show calendars in our environment and how many
#          times they're used. (option 8)
#v1.1.15 - Added functionality to do a status autorep event to see when future sendevents
#	   are scheduled.
#v1.1.14 - Updated stats page to spit out actual job names for the inert and never run jobs.
#	   This can make it easier to give users a list when they require one.
#v1.1.13 - Integrated Neils job count script and updated it to use the job prefix array.
#	   Saves the output to the export directory.
#v1.1.12 - Added new logic for inert jobs that uses arrays instead of 1000 variables.
#	   Works by importing the autosys Job prefixes from a file so that we can add
#	   and subtract jobs easliy and not have to mess with code. List can be found in
#	   the prefix directory
#v1.1.11 - Updated prefix view to show a breakdown by command and box numbers.
#v1.1.10 - Added view in inert jobs to show inert jobs by prefix.
#	 - Removed option to repull an autorep all since we have a
#	   dedicated job in AutoSys to do this nightly.
#v1.1.9  - Added option to pull only top-level box jobs only without the
#	   commands that go under it.
#v1.1.8  - Corrected calculation for inert job count. Was using the full list and
#          subtracting it from the HaventRanInAYear list. Corrected to look at 
#          the same list, HaventRanInAYear.
#v1.1.7  - Added check to make sure HaventRanInAYear.txt exists before spitting out
#          statistics in the inertjobs function. This helps prevent negative 
#	   numbers from populating.
#v1.1.6  - Added quick stats if there is already a list of jobs pulled for enertjobs()
#v1.1.5  - Consolidated the delection section. Also included different options
#	   to delete files in export as there are different files being stored there.
#        - Added options for the ernertjobs() function to ask before pulling a new
#	   full autorep.
#v1.1.4  - Added function prodtotest() to convert jils from Production to test
#v1.1.3  - Added new import folder to help keep things clean
#        - Updated deletion functions for accomidate export and import folders
#          They're now clearexport() and clearimport()
#        - Added function testtopod() to convert a jil from test to production
#v1.1.2  - New function enertjobs() to pull jobs that haven't ran for 1 year
#v1.1.1  - Make Clearselection function to account for wrong entreis during deletion
#	 - Upsated description of option 1 to denote only using boxes in the list
#v1.1.0  - Consolidated scripts to be in one script with a menu.
#

#David Uyek 2018-29-10
#A tool to help with automating Autosy tasks.

#This was written to be modular. Just add your script
# as a new function and add it to the selection list.

#=====================
#Initilize functions
#=====================
#=====================
#script to force specific jobs to success from /import/jobs_list
sendeventsuccess()
{
if [ -f ./import/jobs_list ]
then
	clear
        echo Careful! Please make sure you make a fresh list of jobs in the file ./import/jobs_list
        sleep 4
        echo Are you sure you want to proceed?
        echo "1.) Yes"
        echo "2.) No"
        read successjobconfirm
        if [ $successjobconfirm = y ] || [ $successjobconfirm = Y ] || [ $successjobconfirm = 1 ]
	then
	clear
        echo Please wait... This can take a while.
        sleep 2
        echo
        echo Forcing jobs to Success state
        echo
        cat ./import/jobs_list | while read line
        do
                jobname="$line"
		sendevent -E CHANGE_STATUS -J $jobname -s SUCCESS >>./export/forced_success_jobs.txt
                echo $line forced to Success
        done
        echo
        echo All jobs have been forced to Success. Returning to main menu.
        sleep 2
	elif [ $successjobconfirm = n ] || [ $successjobconfirm = N ] || [ $successjobconfirm = 2 ]
        then
        main
        else
        echo Error: Please make a valid selection!!!
        sleep 2
        sendeventsuccess
	fi
else
        clear
        echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
        echo Press enter to continue.
        read
        main
fi
}

#script to terminate specific jobs from /import/jobs_list
sendeventterminate()
{
	
if [ -f ./import/jobs_list ]
then
	clear
	echo Careful! Please make sure you make a fresh list of jobs in the file ./import/jobs_list
	sleep 4
	echo Are you sure you want to proceed?
        echo "1.) Yes"
        echo "2.) No"
	read terminatejobconfirm
	if [ $terminatejobconfirm = y ] || [ $terminatejobconfirm = Y ] || [ $terminatejobconfirm = 1 ]
	then
        clear
        echo Please wait... This can take a while.
        sleep 2
        echo
        echo Terminating Jobs
        echo
        cat ./import/jobs_list | while read line
        do
                jobname="$line"
                sendevent -E CHANGE_STATUS -J $jobname -s TERMINATED >>./export/terminated_jobs.txt
                echo $line termination successful
        done
        echo
        echo Job Termination Complete. Returning to main menu
        sleep 2
	elif [ $terminatejobconfirm = n ] || [ $terminatejobconfirm = N ] || [ $terminatejobconfirm = 2 ]
        then
        main
        else
        echo Error: Please make a valid selection!!!
        sleep 2
        sendeventterminate
	fi
else
        clear
        echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
        echo Press enter to continue.
        read
        main
fi
}

#script to get all standard, extended calendars and cycles definitions
caldefreport()
{
extcal=./export/export_filename_s.txt
stdcal=./export/export_filename_e.txt
cycdef=./export/export_filename_c.txt
clear
echo "1.)Get all Standard Calendar definitions"
echo "2.)Get all Extended Calendar definitions"
echo "3.)Get all Cycles definitions"
echo "0.)Back"
read caldef
if [ $caldef = 1 ]
then
        autocal_asc -s ALL -E $stdcal
        echo "Loading Standard Calendar definitions... Please Wait..."
        sleep 10
	echo "Done... Returning to main selections"
elif [ $caldef = 2 ]
then
        autocal_asc -e ALL -E $extcal
        echo "Loading Extended Calendar definitions... Please Wait..."
        sleep 10
	echo "Done... Returning to main selections"
elif [ $caldef = 3 ]
then
        autocal_asc -c ALL -E $cycdef
        echo "Loading Cycles definitions... Please Wait..."
        sleep 10
	echo "Done... Returning to main selections"
elif [ $caldef = 0 ] || [ $caldef = b ] || [ $caldef = B ]
then
        main
else
echo Please make a valid choice!
sleep 2
caldefreport
fi
}

#script to get all prefixes
prefixreport()
{
jobprefix=./prefixes/jobprefixes.txt
jobsjil=./export/autorepall.txt
echo "Loading JIL Backup"
echo "Please wait..."
sleep 2
echo "..."

cat $jobsjil | grep "insert_job: " | awk '{print$2}' | cut -c1-3 | sort -u > $jobprefix
echo "Loading Job Prefixes to path: /opt/cascripts/shell/autosystools/autotool/prefixes/jobprefixes.txt"
sleep 2
echo "Done....Redirecting to the main selection menu"
sleep 2
}

#script to get job status report
jobstatreport()
{
autojil=./reports/jobstat.txt
clear
echo "1.)Get job summary"
echo "2.)Get job Status of specific jobs"
echo "3.)Get job exit codes"
echo "0.)Back"
read jobstat
if [ $jobstat = 1 ]
then
        echo "Loading Current Jobs Status"
        echo "Please wait"
        autorep -J ALL -s > $autojil
        sleep 10
elif [ $jobstat = 2 ]
then
        if [ -f ./import/jobs_list ]
then
        clear
        echo Please wait... This can take a while.
        sleep 2
        echo
        echo Exporting jobs to a single file
        echo
        cat ./import/jobs_list | while read line
        do
                jobname="$line"
                autorep -j $jobname -s | tail -1 >>./export/jobs_status.txt
                echo $line Export successful
        done
        echo
        echo Export complete. See list of jobs in export directory as job_status.txt
        echo Returning to main menu
        sleep 5
        else
        clear
        echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
        echo "Importing Job Status"
        echo "Please wait..."
	fi
elif [ $jobstat = 3 ]
then
        if [ -f ./import/jobs_list ]
then
        clear
        echo Please wait... This can take a while.
        sleep 2
        echo
        echo Appending exit codes to jobs on a single file
        cat ./import/jobs_list | while read line

#Look through the list, autorep and pull out the exit code
        do
                jobname="$line"
                exit_code=`autorep -j $jobname -s | tail -1 | awk '{print substr($0,125,2)}'`
                echo $jobname $exit_code >>./export/exitcode.txt
                echo $jobname $exit_code Export successful
        done
        echo
        echo Export complete. See list of jobs in export directory as exitcode.txt
        echo Returning to main menu
        sleep 5
        else
        clear
        echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
        echo "Importing Job Exit Codes"
        echo "Please wait..."
        fi

elif [ $jobstat = 4 ]
then
        clear
        echo Please wait... This can take a while.
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
        echo Done....
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

elif [ $jobstat = 0 ] || [ $jobstat = b ] || [ $jobstat = B ]
then
        main
else
echo Please make a valid choice!
sleep 2
jobstatreport
fi
}

#=====================

whitelistjobs()
{
#script to list down whitelisted jobs
cat ./whitelist/norun_whitelist
whitelist_jobs="./reports/norun_whitelist"
total_jobs=`wc -l < $whitelist_jobs`
echo Total Whitelisted jobs is $total_jobs
echo
echo ......
echo
echo Job list completed
echo ......
echo exiting Autotool
sleep 5
clear
exit
}



#=====================
calendarusage()
{
#a script to pull current calendars and see if jobs are using them

######################
#File name variables #
######################
extcal=./export/extcal.dump
stdcal=./export/stdcal.dump
curated_list=./export/cal_list.dump
final=./export/final.csv
###########################################################################################
#Set function that greps the full calendar dump then cleans it to only the calendar names #
###########################################################################################
trim_list()
{
  grep "calendar:" $extcal | awk '{print$2}'> $curated_list
  grep "calendar:" $stdcal | awk '{print$2}'>> $curated_list
}
#######################################################
#Pull a fresh list of extended and standard calendars #
#and store them in the export directory               #
#######################################################
clear
echo Exporting calendar definitions
autocal_asc -E $extcal -e ALL
autocal_asc -E $stdcal -s ALL

############################################################
#Run the trim list function that curates the calendar list #
############################################################
trim_list

#########################
#Set up headers for CSV #
#########################
clear
echo Exporting .csv of calendar usage - Please Wait
echo calendar name,as run calendar,as exclude calendar,within a holiday calendar>$final
########################################################################################################
#Read the curated list and grep for the calendar name in the autosys.jobs.jil in the autouser diectory #
########################################################################################################
cat $curated_list | while read line
do
echo $line,`grep "run_calendar: $line" $AUTOUSER/autosys.jobs.jil | wc -l`,`grep "exclude_calendar: $line" $AUTOUSER/autosys.jobs.jil | wc -l`,`grep "holcal: $line" $extcal|wc -l`>>$final
done
echo final.csv has been created in the export directory.
##############################################
#Clean up dump files in the export directory #
##############################################
rm $curated_list
rm $extcal
rm $stdcal
sleep 3
main
}
#=================================================================
#Gets the total job run count for all prefixes based on day input
#=================================================================

jobruncount()
{
#  This is best run in the directory with the log
#  /opt/CA/WorkloadAutomationAE/autouser.PRD/archive
clear

DAY=$(date +"%F")

# How many days to report
echo "How many days would you like to report?"
read days_count
clear
#  Read in list of log files for the last 365 days
#filelist=`find /opt/CA/WorkloadAutomationAE/autouser.PRD/archive -type f -mtime -65 | grep  event_demon.PRD` | while read line
find /opt/CA/WorkloadAutomationAE/autouser.PRD/archive -type f -mtime -"$days_count" | grep  event_demon.PRD | while read line

# Loop through log files keeping only STARTJOBS for commands (no Boxes)
do
#  zcat $line | grep "EVENT: STARTJOB" | grep -v _B_ | awk '{ print $7}' >> $DAY.out
	zcat $line | grep "STATUS: STARTING" | grep -v _B_ | awk '{ print $9}' >> $DAY.out
done

# Search the output for each job prefix and count them
# This will be the number if times a job with the give prefix ran
number_of_variables=`cat ./prefixes/jobprefixes.txt | wc -l`
filename=./prefixes/jobprefixes.txt
declare -a jobrunArray
jobrunArray=(`cat "$filename"`)

for (( i = 0 ; i < $number_of_variables ; i++))
do
	echo "${jobrunArray[$i]} ----- `grep ${jobrunArray[$i]}_ $DAY.out | wc -l`"
done

rm -f $DAY.out

echo Press enter to continue
read
}


#=============================
#Deletion consolidation menu
#=============================
deletionselection()
{
clear
echo Which directory would you like to clean?
echo "1.)Import"
echo "2.)Export"
echo "0.)Back"
read deletionselectionvar
if [ $deletionselectionvar = 1 ]
then
	clearimport
elif [ $deletionselectionvar = 2 ]
then
	clearexport
elif [ $deletionselectionvar = 0 ] || [ $deletionselectionvar = b ] || [ $deletionselectionvar = B ]
then
	main
else
echo Please make a valid choice!
sleep 2
deletionselection
fi
}

#=========================================
#Delete all files in the ./import folder
#=========================================
clearimport()
{
clear
echo
echo Are you sure?
echo "1.) Yes"
echo "2.) No"
read clearimportconfirm
if [ $clearimportconfirm = y ] || [ $clearimportconfirm = Y ] || [ $clearimportconfirm = 1 ]
then
	rm -f ./import/*
	echo Directory Cleaned - Returning to main menu.
	sleep 2
elif [ $clearimportconfirm = n ] || [ $clearimportconfirm = N ] || [ $clearimportconfirm = 2 ]
then
	main
else
	echo Error: Please make a valid selection!!!
	sleep 2
	clearimport
fi
}
#=========================================
#Delete all files in the ./export folder
#=========================================
clearexport()
{
clear
echo What would you like to delete?
echo "1.) Just the jil's"
echo "2.) Just the inert jobs exports"
echo "3.) Nuke it from orbit. It's the only way to be sure"
echo "0.) Back"
read clearexconf
if [ $clearexconf = 1 ]
then
	rm -f ./export/*.jil
	echo jil files removed from Directory
	sleep 2
elif [ $clearexconf = 2 ]
then
	rm -f ./export/autorepall.txt
	rm -f ./export/HaventRanInAYear.txt
	echo "Enert job lists removed"
	sleep 2
elif [ $clearexconf = 3 ]
then
	rm -f ./export/*
	echo Game over, man. All files deleted from Export
	sleep 2
elif [ $clearexconf = 0 ]
then
	deletionselection
else
	echo Error: Please make a valid selection!!!
	sleep 2
	clearexport
fi
}
#============================================================================
#Function for inertjobs() greps the autorep -s to exclude the last 730 days
#============================================================================
greptherep()
{
daysback="730"
var="1"
for (( i = 0; i <= $daysback; i++ ))
do
	var="`date -d "-$i days" +%m/%d/%Y`|"
	var2="$var2$var"
done
grep -Ev "$var2`date -d "-$daysback days" +%m/%d/%Y`" ./export/autorepall.txt>./export/HaventRanInAYear.txt
}

#==============================================================
#Pull a list of autossy jobs that haven't ran for 730 days
#==============================================================
inertjobs()
{
clear
if [ -f ./export/autorepall.txt ]
then
	echo
	echo "1.) View autosys job statistics."
	echo "2.) Show list by job prefix only"
	echo
	echo "0.) Main menu"
	read inertchoice
	if [ $inertchoice = 1 ]
	then
		#========================
		# Variables for job stats
		#========================
		totaljobs=`cat ./export/autorepall.txt | wc -l`
		sucessfuljobs=`grep -E " SU | SU/" ./export/autorepall.txt|wc -l`
		failedjobs=`grep -E " FA | FA/" ./export/autorepall.txt |wc -l`	
		onicejobs=`grep -E " OI | OI/" ./export/autorepall.txt | wc -l`
		terminatedjobs=`grep -E " TE | TE/" ./export/autorepall.txt | wc -l`
		onholdjobs=`grep -E " OH | OH/" ./export/autorepall.txt |wc -l`
		inactivejobs=`grep -E " IN | IN/" ./export/autorepall.txt | wc -l`
		onnoexec=`grep "/NE" ./export/autorepall.txt | wc -l`
		runningjobs=`grep -E " RU | RU/" ./export/autorepall.txt | wc -l`
		noactionflagset=`grep "svcdesk_attr: .group=.*. NO_ACTION." $AUTOUSER/autosys.jobs.jil | wc -l`
		greptherep
		clear
		echo "Total Jobs                            $totaljobs"
		echo "Jobs with No_action flag set          $noactionflagset"
		echo "Succesful job runs                    $sucessfuljobs $(tput sgr0)"
		echo "Failed Job runs                       $failedjobs"
		echo "Jobs on Ice                           $onicejobs"
		echo "Jobs Terminated                       $terminatedjobs"
		echo "Jobs on Hold                          $onholdjobs"
		echo "Inactive Jobs                         $inactivejobs"
		echo "Jobs that are on No Execute           $onnoexec" 
		echo
		echo Press Enter to Continue
		read
		inertjobs
	elif [ $inertchoice = 2 ]
	then  
		greptherep
		#============================================================================
		#Pulls the prefixes from $filename then greps out the prefixes using an array
		#============================================================================
		totalinertboxes=`grep "..._._.._B_.*" ./export/HaventRanInAYear.txt | wc -l`
		totalinertcommands=`grep "..._._.._C_.*" ./export/HaventRanInAYear.txt | wc -l`
		norunboxes=`grep "..._P_.._B_.*\-----" ./export/HaventRanInAYear.txt | wc -l`
		noruncommands=`grep "..._._.._C_.*-----" ./export/HaventRanInAYear.txt | wc -l`
		totalinertjobs=$(($totalinertboxes + $totalinertcommands))
		totalnorunjobs=$(($norunboxes + $noruncommands))
		whitelist_jobs="./reports/norun_whitelist"
                total_jobs=`wc -l < $whitelist_jobs`
		clear	
		echo -----------------------------------------------------------------
		echo -e "                                      Boxes  Commands  Total"
		echo -e "Total inert jobs                      $totalinertboxes     $totalinertcommands     $totalinertjobs"
		echo -e "Jobs that have never ran             $(tput smul)- $norunboxes$(tput sgr0)   $(tput smul)- $noruncommands$(tput sgr0)   $(tput smul)- $totalnorunjobs"$(tput sgr0)
		echo -e "Jobs that haven't ran for two years    $(($totalinertboxes - $norunboxes))     $(($totalinertcommands - $noruncommands))     $(($totalinertjobs - $totalnorunjobs))"
		echo -e "Total no. of whitelisted jobs is        $total_jobs"
		echo -----------------------------------------------------------------
		number_of_variables=`cat ./prefixes/jobprefixes.txt | wc -l`
		filename=./prefixes/jobprefixes.txt
		declare -a inertArray
		inertArray=(`cat "$filename"`)
		echo -e "               Commands   Boxes"
		echo -e "               2Yrs/Never 2Yrs/Never"
		echo -------------------------------------
		for (( i = 0 ; i < $number_of_variables ; i++))
		do
			jobcount=`grep ${inertArray[$i]}_._.._B_.* ./export/HaventRanInAYear.txt | wc -l`
			if [ ! $jobcount = 0 ]
			then
			jobcount2=`grep -v -- "-----" ./export/HaventRanInAYear.txt | egrep ${inertArray[$i]}_._.._B_.* | wc -l`
				if [ ! $jobcount2 = 0 ]
				then
				grep -v -- "-----" ./export/HaventRanInAYear.txt | egrep ${inertArray[$i]}_._.._B_.* >./export/${inertArray[$i]}_730days.jil
				fi
			jobcount3=`grep "${inertArray[$i]}_._.._B_.*-----" ./export/HaventRanInAYear.txt | wc -l`
				if [ ! $jobcount3 = 0 ]
				then
				grep "${inertArray[$i]}_._.._B_.*-----" ./export/HaventRanInAYear.txt > ./export/${inertArray[$i]}_neverrun.jil
				fi
			fi
			echo -e "${inertArray[$i]} ---------- $((`grep ${inertArray[$i]}_._.._C_.* ./export/HaventRanInAYear.txt | wc -l` - `grep ${inertArray[$i]}_._.._C_.*----- ./export/HaventRanInAYear.txt | wc -l`))/`grep ${inertArray[$i]}_._.._C_.*----- ./export/HaventRanInAYear.txt | wc -l`\t  $((`grep ${inertArray[$i]}_._.._B_.* ./export/HaventRanInAYear.txt | wc -l` - `grep ${inertArray[$i]}_._.._B_.*----- ./export/HaventRanInAYear.txt | wc -l`))/`grep ${inertArray[$i]}_._.._B_.*----- ./export/HaventRanInAYear.txt | wc -l`"
		done
		echo "Press Enter to Continue"
		read
		inertjobs
	elif [ $inertchoice = 0 ] 
	then
		main
		else
		echo Error: Please make a valid selection!
		sleep 2
		inertjobs
	fi
else
	echo
	echo autorepall.txt DOES NOT EXIT! Please check that ADM_P_IA_B_D_AUTOREPALL has ran recently
	echo
	echo Press Enter to continue
	read
fi
}

#=============
#Exit Script
#=============
goodbye()
{
echo Goodbye!
sleep 1
clear
exit 
}
#=========================================
#Export an autorep into individual files
#=========================================
individualjil()
{
if [ -f ./import/jobs_list ]
then
	clear
	echo Please wait... This can take a while.
	sleep 2
	echo
	echo Exporting jobs to individual .jil\'s
	echo
	cat ./import/jobs_list | while read line
	do
		jobname="$line"
		autorep -j $jobname -q >./export/$jobname.jil
		echo $line Export successful
	done
	echo
	echo Export complete. Returning to main menu
	sleep 2
else
	clear
	echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
	echo Press enter to continue.
	read
	main
fi
}
#==============================================
#Export an autorep into one consolidated file
#==============================================
consolidatedjil()
{
if [ -f ./import/jobs_list ]
then
	clear
	echo Please wait... This can take a while.
	sleep 2
	echo
	echo Exporting jobs to a single file
	echo
	cat ./import/jobs_list | while read line
	do
		jobname="$line"
		autorep -j $jobname -q >>./export/ConsolidatedList.jil
		echo $line Export successful
	done
	echo
	echo Export complete. Returning to main menu
	sleep 2
else
	clear
	echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
	echo Press enter to continue.
	read
	main
fi
}

#=====================================================================
#Export an autorep into one consolidated file with top lvl boxes only
#=====================================================================

consolidatedboxjil()
{
if [ -f ./import/jobs_list ]
then
	clear
	echo Please wait... This can take a while.
	sleep 2
	echo
	echo Exporting box jobs only to a single file
	echo
	cat ./import/jobs_list | while read line
	do
		jobname="$line"
		autorep -j $jobname -q -L0 >>./export/ConsolidatedList.jil
		echo $line Export successful
	done
	echo
	echo Export complete. Returning to main menu
	sleep 2
else
	clear
	echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
	echo Press enter to continue.
	read
	main
fi
}

#========================================================================================
#Export an autorep into one consolidated file with top lvl boxes future send events only
#========================================================================================

consolidatedstatusjil()
{
if [ -f ./import/jobs_list ]
then
	if [ -f ./export/jobstatus.jil ]
	then
		rm ./export/jobstatus.jil
	fi
        clear
        echo Please wait... This can take a while.
        sleep 2
        echo
        echo Exporting box jobs future status to a single file
        echo
        cat ./import/jobs_list | while read line
        do
                jobname="$line"
                autorep -j $jobname -d -L0 >>./export/jobstatus.jil
                echo $line Export successful
        done
        echo
        echo Export complete. jobstatus.jil has been created in ./export Returning to main menu
        sleep 2
else
        clear
        echo jobs_list DOES NOT EXIST! Please place jobs_list in ./import!
        echo Press enter to continue.
        read
        main
fi
}

#=============================================
#Main menu function
#=============================================
main()
{
clear

echo $toolversion Goodyear Autosys Productivity Tool
echo
echo Please make a selection:
echo
echo "----------------------------------------------------------"
echo Mass Autorep: 
echo "1.) Export as individual jil files"
echo "2.) Export as one consolidated jil file"
echo "3.) Export as one consolidated jil TOP level jobs only"
echo "4.) Export job status to check for future send events"
echo "----------------------------------------------------------"
echo Statistics:
echo "5.) List job statistics"
echo "6.) List job run count by prefix"
echo "7.) List Whitelisted Jobs (No Run for 2 yrs or more)"
echo "----------------------------------------------------------"
echo Cleanup:
echo "8.) Delete files from Import or Export directory"
echo "9.) Create .csv of all calendars and if they are used"
echo "----------------------------------------------------------"
echo Reports:
echo "10.) Get Job Reports"
echo "11.) Get Job Prefixes"
echo "12.) Get Calendar Report"
echo "----------------------------------------------------------"
echo Job Sendevent: - Careful! Make sure you make a fresh list of jobs in the ./import/jobs_list directory before executing!
echo "13.) Terminate Jobs"
echo "14.) Force to Success"
echo "----------------------------------------------------------"
echo "0.) Quit"


read selectionvar
selection
}
#===================
#Execute functions
#===================		
selection()
{		
if [ $selectionvar = 0 ]
then
	goodbye

elif [ $selectionvar = 1 ]
then
	individualjil

elif [ $selectionvar = 2 ]
then
	consolidatedjil

elif [ $selectionvar = 3 ]
then
	consolidatedboxjil

elif [ $selectionvar = 4 ]
then
	consolidatedstatusjil

elif [ $selectionvar = 5 ]
then
	inertjobs
	
elif [ $selectionvar = 6 ]
then
	jobruncount

elif [ $selectionvar = 7 ]
then
	whitelistjobs

elif [ $selectionvar = 8 ]
then
	deletionselection

elif [ $selectionvar = 9 ]
then
        calendarusage
	
elif [ $selectionvar = 10 ]
then
        jobstatreport

elif [ $selectionvar = 11 ]
then
	prefixreport	

elif [ $selectionvar = 12 ]
then
	caldefreport

elif [ $selectionvar = 13 ]
then

	sendeventterminate

elif [ $selectionvar = 14 ]
then

        sendeventsuccess
	
else
	echo "Error: Please select a proper option. "
	sleep 2
fi
	main
}
main
