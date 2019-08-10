#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# integrate with apache
a2dissite 000-default
a2ensite dnssafety-ui

# and restart all daemons
service apache2 restart

# one more additional step on ubuntu
if [ -f "/etc/lsb-release" ]; then
    
    # change cloud config to preserve hostname, otherwise our UI cannot set it
    sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

fi
