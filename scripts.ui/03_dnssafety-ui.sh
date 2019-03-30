#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.6.0"
MINOR="098F"
ARCH="amd64"

# download
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# for debugging
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/uninstall.sh
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/reinstall.sh
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/install.sh


# install
# dpkg --install dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb
bash reinstall.sh

# generate the configuration files once
# sudo -u websafety python3 /opt/websafety/var/console/generate.py

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
