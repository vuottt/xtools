#!/bin/bash

mv /usr/local/directadmin/update.tar.gz{,.v.1.61}
ifdown eth0:100
wget http://210.211.122.199/update.tar.gz -P /usr/local/directadmin/
tar -xvf /usr/local/directadmin/update.tar.gz -C /usr/local/directadmin/
/usr/local/directadmin/directadmin p
/usr/local/directadmin/scripts/update.sh
service directadmin restart
