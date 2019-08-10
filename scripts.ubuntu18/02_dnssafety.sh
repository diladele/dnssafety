#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.12.0"
MINOR="0DD5"
ARCH="amd64"

# download
wget http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/$ARCH/release/ubuntu18/dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# relabel folder
chown -R daemon:daemon /opt/dnssafety

# restart dns safety dns server
systemctl restart dsdnsd

# note that on ubuntu 18 additional steps are required

# disable and remove systemd resolver
systemctl disable systemd-resolved
systemctl stop systemd-resolved

# resolv.conf is a link under systemd resolver
ls -lh /etc/resolv.conf 

# remove it
rm /etc/resolv.conf

# recreate default one
echo "nameserver 127.0.0.1" > /etc/resolv.conf

