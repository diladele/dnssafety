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
pushd core.$OSNAME
bash 02_dnssafety.sh && bash 03_integrate.sh
popd

# install dns UI
pushd ui.deb
bash 01_apache.sh && bash 02_dnssafety-ui.sh && bash 03_integrate.sh
popd

# tell 
echo "SUCCESS"
echo "SUCCESS"
echo "SUCCESS Now run va.sh script for the appliance or azure-*.sh or aws-*.sh for cloud instances!"
echo "SUCCESS"
echo "SUCCESS"
