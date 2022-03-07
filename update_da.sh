#!/bin/bash

mv /usr/local/directadmin/update.tar.gz{,.v.1.61}
if [[ $(hostnamectl | grep openvz) ]]; then
/sbin/ip addr del 210.211.122.199/32  dev venet0:101
/sbin/ip addr del 210.211.122.197/32  dev venet0:101
sed -i 's/210.211.122.197/210.211.122.199/g' /sbin/daifdown
sed -i 's/210.211.122.197/210.211.122.199/g' /sbin/daifup
else
ifdown eth0:100
ifdown eht0:101
ifdown ens18:100
ifdown ens18:101
fi
wget http://210.211.122.199/update.tar.gz -P /usr/local/directadmin/
tar -xvf /usr/local/directadmin/update.tar.gz -C /usr/local/directadmin/
/usr/local/directadmin/directadmin p
/usr/local/directadmin/scripts/update.sh
service directadmin restart
ifup eth0:100
ifdown eht0:101
ifdown ens18:100
ifdown ens18:101
