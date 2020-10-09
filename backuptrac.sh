#!/bin/bash



#PARAMS
no_of_backups_to_keep=1

test_mode="true"

echo "Begin backing up the data, inside the container."
#backup the node first inside the container
docker exec otnode node /ot-node/current/scripts/backup.js --configDir=/ot-node/data
#Send in the script to do the graft - UPTOHERE
docker cp ./dockerwork.sh otnode:/ot-node/backup/dockerwork.sh
#ls ./backup


echo "Move into the container"
docker exec -it otnode bash
sleep 2
cd ../

sleep 1
echo "Create backup folder if it does not already exist"
mkdir -p backup
cd backup





#Get current directory name
current_directory_name=${PWD##*/}
if [[ "$current_directory_name" == "backup" ]]; then
echo "We are inside the backup directory!"
else
echo "We are not inside the backup directory inside the container. Aborting as delete command will be too dangerous!"
exit 1
fi



#CLEAN UP the backups except last one
if [[ "$test_mode" == "true" ]]; then
echo "TEST MODE ONLY"
  find -maxdepth 1 -type d ! -wholename $(find -type d -printf '%T+ %p\n' | sort -r | head -1 | cut -d" " -f2) ! -wholename "." | awk 'NR>1'
else
echo "LIVE MODE"
  find -maxdepth 1 -type d ! -wholename $(find -type d -printf '%T+ %p\n' | sort -r | head -1 | cut -d" " -f2) ! -wholename "." | awk 'NR>1' -exec rm -r -v {} +
fi
echo "Calling exit"
exit
cd ~
echo "Copying backup folder to node from docker container"
docker cp otnode:/ot-node/backup ./
echo "completed"
