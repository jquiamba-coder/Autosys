# Script to centralize, archive and compress AutoSys application logs for audit compliance
#
# Neil Komorek 20220519
###################################################################

HOST=`hostname`
echo $HOST

if [ $HOST = akrsrv315.na.goodyear.com ]
then
    APPLICATION=PRO
    EVENT_DEMON="event_demon."
    echo $APPLICATION
elif [ $HOST = akrsrv316.na.goodyear.com ]
then
    APPLICATION=PRO
    EVENT_DEMON="event_demon.shadow."
    echo "$APPLICATION Shadow"
elif [ $HOST = akrsrv317.na.goodyear.com ]
then
    APPLICATION=TST
    EVENT_DEMON="event_demon."
    echo $APPLICATION
elif [ $HOST = akrsrv318.na.goodyear.com ]
then
    APPLICATION=TST
    EVENT_DEMON="event_demon.shadow."
    echo "$APPLICATION Shadow"
else
    echo "Unknown environment, exiting."
    exit
fi

# Set file names
EVENT_DEMON="${EVENT_DEMON}${APPLICATION}"
echo $EVENT_DEMON

# Copy as_server and event_demon log to archive folder
cp -p $AUTOUSER/out/as_server.$APPLICATION.* $AUTOUSER/archive
cp -p $AUTOUSER/out/$EVENT_DEMON.* $AUTOUSER/archive


# Remove old files form the out folder
rm -f $AUTOUSER/out/as_server.${APPLICATION}.*
rm -f $AUTOUSER/out/$EVENT_DEMON.*
rm -f $AUTOUSER/out/aggregator.${APPLICATION}.*

find $AUTOUSER/out -name catalina.\* -mtime +30 -delete
find $AUTOUSER/out -name waae_webservices_access_log.\* -mtime +30 -delete


# Compress all currently uncompressed files in the archive folder
cd $AUTOUSER/archive
gzip -q *


# Remove old logs
find $AUTOUSER/archive -mtime +485 -delete

