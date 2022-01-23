#!/bin/bash

#Check Disk Cyberpanel

DATE=`date`
for website in $(cyberpanel listWebsitesPretty | awk {'print $4'} | grep -v Domain | sed '/^[[:space:]]*$/d'); do
	DIR="/home/$website/backup/backup-"
	if [ -d ${DIR}* ] 2>/dev/null; then
		rm -rf /home/$website/backup/backup-*
		echo "$DATE - Xoa backup website $website" >> /var/log/backup-clean.log
	else
		echo "$DATE - Backup khong ton tai website $website" >> /var/log/backup-clean.log
	fi
done
