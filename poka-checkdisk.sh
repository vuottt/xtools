#!/bin/sh
ALERT=90 # bao nhieu % se canh bao
ADMIN="vuottt@gmail.com" # sys email
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read -r output;
do
#  echo "$output"
  usep=$(echo "$output" | awk '{ print $1}' | cut -d'%' -f1 )
  partition=$(echo "$output" | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    /usr/bin/curl -s https://raw.githubusercontent.com/vuottt/xtools/main/poka-backupclean.sh | bash
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date). Cleaned." >> /var/log/backup-clean.log
  fi
done
