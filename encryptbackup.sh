#!/bin/bash
echo "START encryptbackup.sh"
cd /ot-node/backup/
#Get one filename from list.  This is the last backup
dir_to_encrypt=$(find  . -name '2020*' | grep ":" | sort -r -z | head -n 1)
shcreate="encrypt.sh"
echo "dir_to_encrypt is $dir_to_encrypt"

#Replace the colons with underscores
sanitized_filename=$(echo "$dir_to_encrypt.tar.gz" | sed -r 's/[:]+/_/g')

echo "Sanitized filename is $sanitized_filename"
#Create a encrypt.sh file which when ran will encrypt the last backup into tar

echo "#!/bin/bash" > $shcreate
echo "tar -Scvzf $sanitized_filename $dir_to_encrypt" >> $shcreate
#Write the last encrypted file into a log for easy retrieval
touch "last_encrypted.log"
echo "$sanitized_filename" > "last_encrypted.log"
if [ -f "$sanitized_filename" ]; then
    echo "$sanitized_filename EXISTS!"
else
echo "$sanitized_filename DOES NOT EXIST!"
fi

#Permission and run to encrypt the last backup
chmod +x $shcreate
echo "START $shcreate now"
sleep 5
./$shcreate
