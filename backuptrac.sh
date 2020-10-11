#!/bin/bash

echo "Begin backing up the data, inside the container."
#backup the node first inside the container
docker exec otnode node /ot-node/current/scripts/backup.js --configDir=/ot-node/data
sleep 2

#Remove the key sh files if they already exist
docker exec otnode rm /ot-node/backup/encryptbackup.sh 2> /dev/null
docker exec otnode rm /ot-node/backup/clearalldirectorybackups.sh 2> /dev/null

#Add the key sh files fresh

#docker cp ./dockerwork.sh otnode:/ot-node/backup/dockerwork.sh

#Copy the key script files into the docker container
docker cp ./clearalldirectorybackups.sh otnode:/ot-node/backup/clearalldirectorybackups.sh
docker cp ./encryptbackup.sh otnode:/ot-node/backup/encryptbackup.sh

#Run the encryptback.sh
docker exec otnode bash -c "/ot-node/backup/encryptbackup.sh"

#Run clear all directory backups
sleep 2

echo "Copying the encrypted filename from docker container"

docker cp otnode:/ot-node/backup/last_encrypted.log ~/trac-a-backup/
last_enc_filename=$(<last_encrypted.log)
echo "last_enc_filename is $last_enc_filename"
docker cp otnode:/ot-node/backup/$last_enc_filename ~/trac-a-backup/

sleep 2

#Clear all directory backups.
echo "Running clearalldirectorybackups.sh"

docker exec otnode bash -c "/ot-node/backup/clearalldirectorybackups.sh"
echo "### exiting backuptrac.sh ###"
exit
