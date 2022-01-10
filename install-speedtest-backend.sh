#!/bin/bash

#Script cai backend cho trang speedtest.vinahost.vn

        WGET=/usr/bin/wget
        TAR=/usr/bin/tar
${WGET} --no-check-certificate https://upload-vpn.vinahost.vn/d4kjBN/backend.tar.gz
${TAR} -xvf backend.tar.gz -C /var/www/html/
