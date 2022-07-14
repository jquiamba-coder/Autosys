###############################################
#Script: globerrs10.sh Author: Julius Quiambao#
#Description: Script that autoreps the jobs   #
#not using threshold resources                #
#                                             #
###############################################

autorep -J ALL -q | grep "insert_job: " -B 2 -A 12 | grep -v -e "resources: (thr_" -e "notification_emailaddress:" -e "condition:" -e "date_conditions:" -e "permission:" -e "owner:" -e "machine:" -e "profile:" -e "alarm_if_fail:" -e "std_err_file:" -e "std_out_file:" -e "description:" -e "command:" -e "box_name:" -e "run_calendar:" -e "start_times:" -e "application:" -e "------" -e "--" -e "days_of_week:" -e "start_mins:" -e "timezone:" -e "term_run_time:" -e "box_terminator:" -e "send_notification:" -e "job_terminator:" -e "svcdesk_attr:" -e "box_success:" -e "watch_file:" -e "max_run_alarm:" -e "run_window:" -e "n_retrys:" -e "notification_msg:" | grep "job_type: BOX" | awk '{print$2}' > /opt/cascripts/shell/autosystools/autotool/reports/jobs_without_threshold_resources.list

