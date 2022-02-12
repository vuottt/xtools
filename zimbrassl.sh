
yum install snapd
service snapd start
ln -s /var/lib/snapd/snap /snap
snap install --classic certbot
certbot certonly --standalone --preferred-chain "ISRG Root X1" -d mail.trungsonpharma.com

86  220212 15:54:59 /opt/zimbra/bin/zmcertmgr verifycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.key /etc/letsencrypt/live/mail.trungsonpharma.com/cert.pem /etc/letsencrypt/live/mail.trungsonpharma.com/chain.pem
   87  220212 15:55:38 /opt/zimbra/bin/zmcertmgr deploycrt comm /etc/letsencrypt/live/mail.trungsonpharma.com/cert.pem /etc/letsencrypt/live/mail.trungsonpharma.com/chain.pem
   88  220212 15:55:59 zmcontrol restart
