#!/bin/bash

if [[ $(/usr/bin/curl -s -u admin:zq0lSMu6TjMfWEo http://210.211.122.199:2222 | grep Expired) ]]; then

	gzip < /usr/local/directadmin/conf/license.key > /var/www/html/license.key.gz
	chmod 644 /var/www/html/license.key.gz
	ln -sf /usr/share/zoneinfo/Asia/Saigon /etc/localtime
	ntpdate asia.pool.ntp.org && hwclock -w > /dev/null

else

	echo "LIcensed - Do nothing"

fi
