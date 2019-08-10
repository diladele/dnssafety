#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.12.0"
MINOR="4011"
ARCH="amd64"

# download
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/debian10/dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# let UI of Dns Safety manage the network
sudo -u daemon python3 /opt/dnssafety-ui/var/console/utils.py --network=debian10

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
