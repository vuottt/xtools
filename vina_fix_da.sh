#!/bin/bash

LICENSE=/usr/local/directadmin/conf/license.key
mv /usr/local/directadmin/update.tar.gz{,.bak}; wget -O /usr/local/directadmin/update.tar.gz http://210.211.122.247/da-1604-centos7.tar.gz
tar -xvf /usr/local/directadmin/update.tar.gz -C /usr/local/directadmin/
/usr/local/directadmin/directadmin p
/usr/local/directadmin/scripts/update.sh
if [[ -f "$LICENSE" ]]; then
  echo "" > $LICENSE
else
  touch $LICENSE
  chmod 600 $LICENSE
  chown diradmin:diradmin $LICENSE
fi
service directadmin restart &
sleep 5
exit 1
