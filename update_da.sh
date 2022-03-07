#!/bin/bash

DA_ETH_DEV=$(grep ethernet_dev /usr/local/directadmin/conf/directadmin.conf | cut -f2 -d"=")

mv /usr/local/directadmin/update.tar.gz{,.v.1.61}
if [[ $(hostnamectl | grep openvz) ]]; then
  echo "Virtualizor la OpenVZ"
  # /sbin/ip addr del 210.211.122.199/32  dev venet0:101
  # /sbin/ip addr del 210.211.122.197/32  dev venet0:101
    if [[ $(ip addr show | grep 210.211.122.199 | awk {'print $7'}) ]]; then
    ETH_DEV=$(ip addr show | grep 210.211.122.199 | awk {'print $7'})
    else
    ETH_DEV=$(ip addr show | grep 210.211.122.197 | awk {'print $7'})
    fi
  #echo "$ETH_DEV chinh la card mang"
  /sbin/ip addr del 210.211.122.197/32  dev $ETH_DEV
  /sbin/ip addr del 210.211.122.199/32  dev $ETH_DEV
  sed -i 's/210.211.122.197/210.211.122.199/g' /sbin/daifdown
  sed -i 's/210.211.122.197/210.211.122.199/g' /sbin/daifup
  sed -i "s/$ETH_DEV/$DA_ETH_DEV/g" /sbin/daifdown
  sed -i "s/$ETH_DEV/$DA_ETH_DEV/g" /sbin/daifup
else
  echo "Virtualizor la KVM"
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
ifdown eth0:100; ifdown ens18:101 && rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://210.211.122.199/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; ifup eth0:100; ifup ens18:101; /bin/systemctl restart  directadmin.service
