#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# recreate default /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# and restart dns safety dns server
systemctl restart dsdnsd
