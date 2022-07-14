pid=`cat <agent_dir>/status|grep -i component|awk '{print $4}'`
timeout 100  strace -o /tmp/straceout_`date '+%Y%m%d%H%M%S'` -f -p $pid
$pid

