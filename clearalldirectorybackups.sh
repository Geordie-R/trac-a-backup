#!/bin/bash
cd /ot-node/backup/
#Removing all but first 3 backups

current_directory_name=${PWD##*/}
if [[ "$current_directory_name" == "backup" ]]; then
echo "We are inside the backup directory!"
ls -t -v | grep ":" | xargs rm -R
echo "finished removing all directory backups containing a colon inside the backup folder"
else
echo "We are not inside the backup directory inside the container. Aborting as delete command will be too dangerous!"
exit 1
fi
