#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default os
OSNAME="debian10"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu18"
fi

# install dns safety
pushd scripts.$OSNAME
bash 02_dnssafety.sh && bash 03_integrate.sh
popd

# install dns UI
pushd scripts.ui
bash 01_apache.sh && bash 02_dnssafety-ui.sh && bash 03_integrate.sh
popd

# install va
pushd scripts.va
bash 01_login.sh && bash 02_harden.sh
popd

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS --- VA is Ready (check the license and publish it) ---"
cat /opt/dnssafety/etc/license.pem | grep "Not After"
echo "SUCCESS"
echo "SUCCESS"
