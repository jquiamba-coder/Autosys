

cat ./tss.list | while read line
do
   jobname="$line"
   forecast -J $jobname -F 08/22/2021 12:01 -T 08/22/2021 18:00  >> sunday-tss.txt
   echo $line Export successful
done

