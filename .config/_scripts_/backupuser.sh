#!/bin/bash
:

BORGDIR="/mnt/data/backups/home"
TODAY=`date +%A`
BORGARCHIVE=${BORGDIR}::${TODAY}

# cleanup some files
rm -rf /home/user/Development/Hubro/manti/dev_db/meteor_db.log.20*

cd /home
borg rename ${BORGARCHIVE} ${TODAY}-pre
borg create -e user/pCloudDrive -e user/Downloads -e user/Videos -e user/Pictures -e user/vms -e user/pcloud -e user/Development/Hubro/backups -x --stats --progress --compression lz4 ${BORGARCHIVE} user
borg delete ${BORGARCHIVE}-pre
borg compact ${BORGDIR}

