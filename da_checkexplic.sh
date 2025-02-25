#!/bin/bash

MESSAGE_BODY="DirectAdmin license hết hạn. Login vào server http://210.211.122.199:2222 kiểm tra ngay"
EMAIL_SUBJECT="DirectAdmin license Expired."
FROM_EMAIL_ADDRESS=""
FRIENDLY_NAME="DirectAdmin CentOS7 License"
SMTP_SERVER=""
SMTP_PORT="25"
SMTP_USER=""
SMTP_PASS=""
TO_EMAIL_ADDRESS=""
NSS_DIR="/etc/pki/nssdb/"


if [[ $(/usr/bin/curl -s -u admin:zq0fdgdgd6TjMfWEo http://210.222.222.222:2222 | grep expired) ]]; then
	
	echo $MESSAGE_BODY | mailx -v -s "$EMAIL_SUBJECT" \
	-S smtp-use-starttls \
	-S ssl-verify=ignore \
	-S smtp-auth=login \
	-S smtp=smtp://$SMTP_SERVER:$SMTP_PORT \
	-S from="$FROM_EMAIL_ADDRESS($FRIENDLY_NAME)" \
	-S smtp-auth-user=$SMTP_USER \
	-S smtp-auth-password=$SMTP_PASS \
	-S ssl-verify=ignore \
	-S nss-config-dir=$NSS_DIR \
	$TO_EMAIL_ADDRESS
	
	/usr/local/directadmin/scripts/getLicense.sh jezuLqLxRFTz+Y9BtCEqPrLd760KRsker0dbVFqystI=
	gzip < /usr/local/directadmin/conf/license.key > /var/www/html/license.key.gz
	chmod 644 /var/www/html/license.key.gz
	ln -sf /usr/share/zoneinfo/Asia/Saigon /etc/localtime
	ntpdate asia.pool.ntp.org && hwclock -w > /dev/null
	service directadmin restart
	echo "$(date) : Da get lai license!" >> /var/log/da_license.log

else
	echo "LIcensed - Do nothing"

fi
