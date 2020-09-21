#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.16.0"
MINOR="F48A"
ARCH="amd64"

# see if it is RPI or not?
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

# default os
OSNAME="debian10"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu18"
fi

# download
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/$OSNAME/dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# let UI of Dns Safety manage the network ONLY on amd64 based Debian 10 or Ubuntu 18, on RPI it is left as not managed
if [ "$ARCH" != "armhf" ]; then
    sudo -u daemon python3 /opt/dnssafety-ui/var/console/utils.py --network=$OSNAME    
fi

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
