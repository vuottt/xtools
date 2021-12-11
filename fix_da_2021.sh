#!/bin/bash

# Fix License DA VinaHost 2021 to 2022

ETH_DEV=$(/usr/sbin/ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

LIC_ETH_DEV="$ETH_DEV:100"

LIC_ETH_DEV_FILE="/etc/sysconfig/network-scripts/$LIC_ETH_DEV"

DA_CRON_DIR="/etc/cron.d/directadmin_cron"

ROOT_CRON_DIR="/var/spool/cron/root"

# Edit IP

if [[ -f "$LIC_ETH_DEV_FILE" ]]; then
	sed -i "s/125.212.251.87/125.212.251.87/g" $LIC_ETH_DEV_FILE
	sed -i "s/255.255.255.192/255.255.255.128/g" $LIC_ETH_DEV_FILE
fi

# Edit Cron

echo "0 12 */3 * * rm -f /tmp/license.key; /usr/sbin/ifdown $LIC_ETH_DEV; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://125.212.251.87/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /bin/systemctl restart  directadmin.service" >> $DA_CRON_DIR

echo "Kiem tra xoa neu co cron cu trong crontab -e"

# Execute

rm -f /tmp/license.key; /usr/sbin/ifdown $LIC_ETH_DEV; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://125.212.251.87/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /bin/systemctl restart  directadmin.service
