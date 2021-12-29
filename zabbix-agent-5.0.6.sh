#!/bin/bash
#Script update Zabbix Agent to 5.6
#IP Viettel or Quoc te su dung IP Zabbix Proxy 125.212.218.37
#IP VNPT su dung Zabbix VDC 123.30.129.229
IP=""
if [[ $(curl -s ipinfo.io | grep "VNPT") ]];then
                IP="123.30.129.229"
                sed -i 's/,123.30.129.229//g' /etc/zabbix/zabbix_agentd.conf
                sed -i '/^Server=/ s/$/,123.30.129.229/' /etc/zabbix/zabbix_agentd.conf
                sed -i '/^ServerActive=/ s/$/,123.30.129.229/' /etc/zabbix/zabbix_agentd.conf
else
                IP="125.212.218.37"
                sed -i 's/,125.212.218.37//g' /etc/zabbix/zabbix_agentd.conf
                sed -i '/^Server=/ s/$/,125.212.218.37/' /etc/zabbix/zabbix_agentd.conf
                sed -i '/^ServerActive=/ s/$/,125.212.218.37/' /etc/zabbix/zabbix_agentd.conf
fi

cp /etc/zabbix/zabbix_agentd.conf{,.save}
#Update..

if [ -f "/etc/redhat-release" ]; then
if [[ $(cat /etc/redhat-release | grep -o "release 5") ]];then
                rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/5/$(uname -m)/zabbix-agent-5.0.6-1.el5.$(uname -m).rpm
                service zabbix-agent restart
elif [[ $(cat /etc/redhat-release | grep -o "release 6") ]];then
                rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/6/$(uname -m)/zabbix-agent-5.0.6-1.el6.$(uname -m).rpm
                service zabbix-agent restart
elif [[ $(cat /etc/redhat-release | grep -o "release 7") ]];then
                rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/$(uname -m)/zabbix-agent-5.0.6-1.el7.$(uname -m).rpm
                systemctl daemon-reload
                systemctl restart zabbix-agent
fi
else
if [[ $(lsb_release -is | tr '[:upper:]' '[:lower:]') == "debian" ]];then
                rm -f zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix/zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                dpkg -i zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                service zabbix-agent restart
elif [[ $(lsb_release -is | tr '[:upper:]' '[:lower:]') == "ubuntu" ]];then
                rm -f zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix/zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                dpkg -i zabbix-agent_5.0.6-2+$(lsb_release -cs)_$(dpkg --print-architecture).deb
                service zabbix-agent restart
else
                echo "OS khong co trong list cai dat, vui long cai dat bang tay"
fi
fi

cat << EOF

========================
Vui logn Allow $IP tren Firewall neu co va
Login Zabbix de kiem tra: https://mon5-vdc.vinahost.vn/
User: staff
Password: vinahost@888
========================
EOF
