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
