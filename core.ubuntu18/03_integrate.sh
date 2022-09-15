#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# disable and remove systemd resolver
systemctl disable systemd-resolved
systemctl stop systemd-resolved

# resolv.conf is a link under systemd resolver
ls -lh /etc/resolv.conf 

# remove it
rm /etc/resolv.conf

# recreate default one
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# restart dns safety dns server
systemctl restart dsdnsd
systemctl status dsdnsd

# wait for the dns resolve to come up
sleep 10

# test it works nicely
dig verify.diladele.com @127.0.0.1
