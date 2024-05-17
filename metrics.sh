#!/bin/bash
        if [ $# -eq 0 ]
                then
                        echo "Usage: metrics url"
                else
                        curl -H 'Cache-Control: no-cache' -Lw "DNS Lookup: %{time_namelookup} seconds \nRedirects: %{time_redirect} seconds with %{num_redirects} redirects \nFirst Byte: %{time_starttransfer} seconds \nConnect Time: %{time_connect} seconds \nTotal Time: %{time_total} seconds\n" -so /dev/null $1
                fi
