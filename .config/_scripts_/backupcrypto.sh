#!/bin/bash
:

ps x | grep pcloud | grep -v grep > /dev/null
if [ "$?" -eq 1 ]; then
  echo "starting pCloud..."
  name=`find ~/Applications -name "pcloud*"`
  $name &>/dev/null &
  sleep 10
fi

cd /mnt/data && rsync -aAXvxt --delete cryptomator_vault ~/pCloudDrive/pCloud\ Sync > /tmp/backupcrypto.log
