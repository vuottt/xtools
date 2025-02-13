wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
cd node_exporter-1.8.2.linux-amd64.tar.gz 
tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz 
cd node_exporter-1.8.2.linux-amd64
 ./node_exporter &
 
if firewall-cmd --state >/dev/null 2>&1; then
  echo "firewall-cmd is running, adding firewall rule..."
   firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="171.244.33.112/32" port protocol="tcp" port="9100" accept'
   firewall-cmd --reload
else
  echo "firewall-cmd is not running or not installed, check your firewall rule"
  service=$(ps ax | grep -c [l]fd)
  if [ $service -le 0 ]; then
    echo "CSF not runnin too"
  else
    echo "CSF Running..."
    sed -i '/^TCP_IN/s/"$/,9100"/' /etc/csf/csf.conf
    csf -ra
  fi
fi
