#!/bin/bash

## Script reset password
## Write by Vuot

IP=`hostname -I`

PASSGEN=$(</dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)

ROOTPASS=$PASSGEN

PASSGEN=$(</dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)

ADMINPASS=$PASSGEN

echo -e "$ROOTPASS\n$ROOTPASS" | passwd root 

if [[ -f /etc/cyberpanel/machineIP ]]; then
	echo "Detect CyberPanel"
	adminPass $ADMINPASS

	cat <<-EOF
	========================
	Thong tin Panel
	URL: https://$IP:8090
	User: admin / $ADMINPASS
	========================
	EOF

else
	echo "VPSSIM. Do Nothing"
fi

cat << EOF
========================
Thong tin tai khoan root
Host: $IP
User: root / $ROOTPASS
========================
EOF
