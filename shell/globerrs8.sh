
###############################################
#Script: globerrs8.sh Author: Julius Quiambao #
#Description: Script that autoreps the jobs   #
#using threshold resources                    #
#                                             #
###############################################

autorep -j ALL -q | grep "resources: (thr_" -B 20 -A 1 | grep -v -e notification_emailaddress: -e resources: -e svcdesk_attr: -e notification_msg: -e send_notification: -e application: -e profile: -e alarm_if_fail: -e std_err_file: -e std_out_file: -e box_terminator: -e description: -e date_conditions: -e permission: -e owner: -e machine: -e command: -e box_name: -e "-----------------" -e condition: -e svcdesk_pri: -e n_retrys: -e svcdesk_desc: -e "--" | awk '{print$2}' > /opt/cascripts/shell/autosystools/autotool/reports/jobs_with_threshold_resources.jil
