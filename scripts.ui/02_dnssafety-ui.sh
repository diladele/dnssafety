#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.13.0"
MINOR="B421"
ARCH="amd64"

# default os
OSNAME="debian10"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu18"
fi

# download
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/$OSNAME/dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# let UI of Dns Safety manage the network
sudo -u daemon python3 /opt/dnssafety-ui/var/console/utils.py --network=$OSNAME

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
