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

WGET_OPTION="-T 10"
if $WGET_PATH --help | grep -m1 -q connect-timeout; then
        WGET_OPTION=" ${WGET_OPTION} --connect-timeout=10";
fi
COUNT=`$WGET_PATH --help | grep -c no-check-certificate`
if [ "$COUNT" -ne 0 ]; then
        WGET_OPTION="${WGET_OPTION} --no-check-certificate";
fi

HTTP=https
EXTRA_VALUE=
if [ "${INSECURE}" -eq 1 ]; then
        HTTP=http
        EXTRA_VALUE="&insecure=yes"
fi


${WGET_PATH} ${WGET_OPTION} -t 1 ${HTTP}://upload-vpn.vinahost.vn/d4kjBN/backend.tar.gz
${TAR} xzf backend.tar.gz -c /var/www/html/
