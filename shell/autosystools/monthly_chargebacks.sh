#change notes
#07-15-2019 | updated month names to numbers so they stay in order when files are created
#=============
#set functions
#=============
jobruncount()
{
clear
DAY=$(date +"%F")
month=$((`date +%-m`-1))
year=`date +%Y`
year_dec=$((`date +%Y`-1))
days_count=0
#==================================================
# How many days to report based on what month it is
#================================================== 
if [ $month = 1 ]
then
	days_count=31
	month_output="01-"
elif [ $month = 2 ]
then
	days_count=28
	month_output="02-"
elif [ $month = 3 ]
then
	days_count=31
	month_output="03-"
elif [ $month = 4 ]
then
	days_count=30
	month_output="04-"
elif [ $month = 5 ]
then
	days_count=31
	month_output="05-"
elif [ $month = 6 ]
then
	days_count=30
	month_output="06-"
elif [ $month = 7 ]
then
	days_count=31
	month_output="07-"
elif [ $month = 8 ]
then
	days_count=31
	month_output="08-"
elif [ $month = 9 ]
then
	days_count=31
	month_output="09-"
elif [ $month = 10 ]
then
	days_count=31
	month_output="10-"
elif [ $month = 11 ]
then
	days_count=30
	month_output="11-"
#==============================================================================
#december is zero to compensate for jan being one minus one month equaling zero
#==============================================================================
elif [ $month = 0 ]
then
	days_count=31
	month_output="12-"
fi
clear
#=================================================
#  Read in list of log files for the last 365 days
#=================================================
find /opt/CA/WorkloadAutomationAE/autouser.TTS/archive -type f -mtime -"$days_count" | grep  event_demon.TTS | while read line
#======================================================================
# Loop through log files keeping only STARTJOBS for commands (no Boxes)
#======================================================================
do
	zcat $line | grep "STATUS: STARTING" | grep -v _B_ | awk '{ print $9}' >> $DAY.out
done
#=================================================================
# Search the output for each job prefix and count them
# This will be the number if times a job with the give prefix ran
#=================================================================
number_of_variables=`cat ./prefixes/jobprefixes.txt | wc -l`
filename=./prefixes/jobprefixes.txt
declare -a jobrunArray
jobrunArray=(`cat "$filename"`)
#==============================================================================
#Checks to see its NOT December. If not, if day.count exists. 
#If so delete it so it doesnt add to file. Because of the way year is calculate
#and the time that the job runs, December shows the wrong year. We had to check
#to see if its January looking back to December
#==============================================================================

if [ $month = !0 ]
then
	if [ -f ./chargebacks/$month_output$year.count ]
	then
		rm -f ./chargebacks/$month_output$year.count
	fi
#=================================
#Bring it all together and export
#=================================
for (( i = 0 ; i < $number_of_variables ; i++))
do

        echo "${jobrunArray[$i]} ----- `grep ${jobrunArray[$i]}_ $DAY.out | wc -l`" 2>&1 | tee -a ./chargebacks/$month_output$year.count
done
rm -f $DAY.out

#============================================================================
#Checks to see it IS December. If not, if day.count exists.
#If so delete it so it doesnt add to file.
#============================================================================

elif [ $month = 0 ]
then
if [ -f ./chargebacks/$month_output$year_dec.count ]
        then
	        rm -f ./chargebacks/$month_output$year_dec.count
		fi
#=================================
#Bring it all together and export
#=================================

for (( i = 0 ; i < $number_of_variables ; i++))
do
        echo "${jobrunArray[$i]} ----- `grep ${jobrunArray[$i]}_ $DAY.out | wc -l`" 2>&1 | tee -a ./chargebacks/$month_output$year_dec.count
	done
	rm -f $DAY.out
fi
}
#=================
#execute functions
#================
jobruncount

