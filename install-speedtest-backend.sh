#!/bin/bash

#Script cai backend cho trang speedtest.vinahost.vn

OS=`uname`;
if [ $OS = "FreeBSD" ]; then
        WGET=/usr/local/bin/wget
        TAR=/usr/bin/tar
        CHOWN=/usr/sbin/chown
        ROOTGRP=wheel
else
        WGET=/usr/bin/wget
        TAR=/bin/tar
        CHOWN=/bin/chown
        ROOTGRP=root
fi


${WGET} --no-check-certificate https://upload-vpn.vinahost.vn/d4kjBN/backend.tar.gz
${TAR} xzf backend.tar.gz -c /var/www/html/
