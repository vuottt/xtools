#!/bin/sh -x
PATH=/bin:/sbin:/usr/bin:/usr/sbin
/bin/sh /etc/profile

#Check Disk Cyberpanel

DATE=`date`
for website in $(cyberpanel listWebsitesPretty | awk {'print $4'} | grep -v Domain | sed '/^[[:space:]]*$/d'); do
        DIR="/home/$website/backup/backup-"
#       if [ -d ${DIR}* ] 2>/dev/null; then
        if ls ${DIR}* 1> /dev/null 2>&1; then
                rm -rf /home/$website/backup/backup-*
                echo "$DATE - Xoa backup website $website" >> /var/log/backup-clean.log
        else
                echo "$DATE - Backup khong ton tai website $website" >> /var/log/backup-clean.log
        fi
done

find /var/lib/lsphp/session/ -type f -delete
echo "$DATE - Cleaned PHP session" >> /var/log/backup-clean.log
