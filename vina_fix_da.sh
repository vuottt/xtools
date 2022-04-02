#!/bin/bash
OSVERSION=$(rpm --eval '%{centos_ver}')
if [[ $OSVERSION -eq 6 ]]; then
  echo "Detect OS CentOS 6. Script khong chay tren CentOS6. Vui long chay lai cron cu trong /etc/cron.d/directadmin_cron"
  exit 1;
fi
WEBSERVICE=$(cat /usr/local/directadmin/custombuild/options.conf  | grep webserver | cut -f2 -d"=")
LICENSE=/usr/local/directadmin/conf/license.key

######License######
mv /usr/local/directadmin/update.tar.gz{,.bak}
wget -O /usr/local/directadmin/update.tar.gz https://uploadwhmcs.vinahost.vn/storage/267/20220314-004403-da-1604-centos7.tar.gz
#wget -O /usr/local/directadmin/update.tar.gz http://210.211.122.247/da-1604-centos7.tar.gz
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
mv /usr/local/directadmin/conf/directadmin.conf{,.original}
wget -O /usr/local/directadmin/conf/directadmin.conf https://raw.githubusercontent.com/vuottt/xtools/main/da_config.txt
chown diradmin:diradmin /usr/local/directadmin/conf/directadmin.conf
chmod 600 /usr/local/directadmin/conf/directadmin.conf

######Systemd######
echo "" > /etc/systemd/system/directadmin.service
cat <<EOF >>/etc/systemd/system/directadmin.service
# DirectAdmin control panel
# To reload systemd daemon after changes to this file:
# systemctl --system daemon-reload
[Unit]
Description=DirectAdmin Web Control Panel
After=syslog.target network.target
Documentation=http://www.directadmin.com

[Service]
Type=forking
PIDFile=/run/directadmin.pid
ExecStart=/usr/local/directadmin/directadmin d
ExecReload=/bin/kill -HUP $MAINPID
WorkingDirectory=/usr/local/directadmin
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
service directadmin restart

######Fix loi /etc/virtual######
cp -Rp /etc/virtual{,.fixbackup}
curl -s https://raw.githubusercontent.com/vuottt/xtools/main/fix_virtual_da.sh | bash
cd /usr/local/directadmin/scripts
./majordomo.sh
cd /usr/local/directadmin/custombuild
sed -i 's/doDAVersionCheck$/doDAVersionCheck:/' build
./build $WEBSERVICE

######Restart######
service directadmin restart
sleep 5
exit 1
