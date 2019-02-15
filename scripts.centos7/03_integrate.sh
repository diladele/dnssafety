#!/bin/bash

# integration should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# allow connections to 53 port both UDP and TCP
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=53/udp
firewall-cmd --reload

# restart dsdnsd just in case
systemctl restart dsdnsd

