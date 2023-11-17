#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# in debian 12 on azure systemd resolver is active, we need to disable it
# failure to do so will mean dsdnsd daemon will not be able to start as
# port 53 would be taken by the systemd resolver
systemctl disable --now systemd-resolved
systemctl stop systemd-resolved

# the Azure deployment insists on this
sed -i 's/ClientAliveInterval 120/ClientAliveInterval 180/g' /etc/ssh/sshd_config
