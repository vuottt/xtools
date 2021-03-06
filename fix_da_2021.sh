#!/bin/bash

# VERSION=`/usr/local/directadmin/directadmin v | awk {'print $3'} | cut -f 3 -d"."`
# if [[ VERSION -ne "63" ]]; then
#  	echo "TUYET DOI KHONG UPDATE DIRECTADMIN"
# 	echo "Script đang trong quá trình cập nhật lại. Không chạy script này trong thời gian này"
#  	exit 1;
# else
# 	echo "Lien het vuottt@vinahost.vn de kiem tra"
# fi

# Fix License DA VinaHost from .97 to .99

ETH_DEV=$(/usr/sbin/ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | grep -v "tun" | sed -e 's/^[[:space:]]*//')

LIC_ETH_DEV="$ETH_DEV:100"

# echo "Device: $LIC_ETH_DEV"

LIC_ETH_DEV_FILE="/etc/sysconfig/network-scripts/ifcfg-$LIC_ETH_DEV"

# echo "Ethernet config: $LIC_ETH_DEV_FILE"

DA_CRON_DIR="/etc/cron.d/directadmin_cron"

ROOT_CRON_DIR="/var/spool/cron/root"

# DA_CONFIG_FILE="/usr/local/directadmin/conf/directadmin.conf"

OS=$(/usr/bin/rpm -E %{rhel})

if [[ OS -ne "7" ]]; then
	echo "Script chi danh cho CentOS 7"
	exit 1;
fi

# # Edit IP

if [[ -f "$LIC_ETH_DEV_FILE" ]]; then
# 	ip addr del 210.211.122.197/25 dev $LIC_ETH_DEV_FILE
# 	sed -i "s/210.211.122.197/125.212.251.87/g" $LIC_ETH_DEV_FILE
# 	sed -i "s/255.255.255.192/255.255.255.128/g" $LIC_ETH_DEV_FILE
	sed -i 's/210.211.122.197/210.211.122.199/g' $LIC_ETH_DEV_FILE
fi

#Remove old cron
sed -i "/update-license.sh/d" $ROOT_CRON_DIR
sed -i "/210.211.122.197/d" $DA_CRON_DIR

# Edit Config
# sed -i "s/210.211.122.197/125.212.251.87/g" $DA_CONFIG_FILE
# Edit Cron
# sed -i "/125.212.251.87/d" $DA_CRON_DIR
# echo "0 12 */3 * * rm -f /tmp/license.key; /usr/sbin/ifdown $LIC_ETH_DEV; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://125.212.251.87/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /bin/systemctl restart  directadmin.service" >> $DA_CRON_DIR


echo "0 12 */3 * * /usr/sbin/ifdown $LIC_ETH_DEV && rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://210.211.122.199/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /usr/sbin/ifup eth0:100; /bin/systemctl restart  directadmin.service" >> $DA_CRON_DIR 

# Fix service voi template cu

cat <<EOF > /sbin/daifup 
#!/bin/bash
sleep 5
/usr/sbin/ifconfig $LIC_ETH_DEV 210.211.122.199 netmask 255.255.255.128
EOF

cat <<EOF > /sbin/daifdown
#!/bin/bash
sleep 5
/sbin/ip addr del 210.211.122.199/25  dev $LIC_ETH_DEV
EOF
#
#Chan update và fix loi build bat update

sed -i.fixDAbackup2328 '2328,2330 {s/^/#/}' /usr/local/directadmin/custombuild/build
sed -i.fixDAbackup27964 '27964,27966 {s/^/#/}' /usr/local/directadmin/custombuild/build

# Execute
sleep 1
# rm -f /tmp/license.key; /usr/sbin/ifdown $LIC_ETH_DEV; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://125.212.251.87/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /bin/systemctl restart  directadmin.service
/usr/sbin/ifdown $LIC_ETH_DEV && rm -f /tmp/license.key; rm -f /usr/local/directadmin/conf/license.key; /usr/bin/wget -O /tmp/license.key.gz http://210.211.122.199/license.key.gz && /usr/bin/gunzip /tmp/license.key.gz && mv /tmp/license.key /usr/local/directadmin/conf/ && chmod 600 /usr/local/directadmin/conf/license.key && chown diradmin:diradmin /usr/local/directadmin/conf/license.key; /usr/sbin/ifup eth0:100; /bin/systemctl restart  directadmin.service
/usr/sbin/ifup $LIC_ETH_DEV
service directadmin start
