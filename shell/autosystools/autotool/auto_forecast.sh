

cat ./nat-dir-box-only.list | while read line
do
   jobname="$line"
   forecast -J $jobname -F 08/22/2021 12:00 -T 08/22/2021 18:00  >> sunday.txt
   echo $line Export successful
done

