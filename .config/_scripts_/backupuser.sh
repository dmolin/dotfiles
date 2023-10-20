#!/bin/bash
:

BORGDIR="/mnt/data/backups/home"
TODAY=`date +%A`
BORGARCHIVE=${BORGDIR}::${TODAY}
MANTI="user/Development/Hubro/manti/apps"

# cleanup some files
rm -rf /home/user/Development/Hubro/manti/dev_db/meteor_db.log.20*

function makeExclusions () {
  echo "-e ${MANTI}/$1/.meteor/local/build -e ${MANTI}/$1/.meteor/local/bundler-cache -e ${MANTI}/$1/.meteor/local/plugin-cache -e ${MANTI}/$1/.meteor/local/server-cache"
}

cd /home
borg rename ${BORGARCHIVE} ${TODAY}-pre
borg create \
  -e user/tmp \
  -e user/borgmount \
  -e user/pCloudDrive \
  -e user/Downloads \
  -e user/Videos \
  -e user/Pictures \
  -e user/vms \
  -e user/cryptomator \
  -e user/.local/share/Cryptomator \
  -e user/Development/Hubro/backups \
  -e user/.local/share/Steam/steamapps \
  `makeExclusions app` \
  `makeExclusions worker` \
  `makeExclusions cronworker` \
  -x --stats --progress --compression lz4 ${BORGARCHIVE} user
borg delete ${BORGARCHIVE}-pre
borg compact ${BORGDIR}

