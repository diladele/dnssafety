#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# the dsdnsd daemon will listen on ports 80, 443 for a 'access blocked page'
# so UI will be running on port 8000, it is already set so in 
# /etc/apache2/sites-available/dnssafety-ui.conf but we also need to set
# apache to listen on port 8000 instead of port 80 (which is taken by dsdnsd)
sed -i 's/Listen 80/Listen 8000/g' /etc/apache2/ports.conf

# now integrate with apache
a2dissite 000-default
a2ensite dnssafety-ui

# and restart all daemons
service apache2 restart

# one more additional step on ubuntu
if [ -f "/etc/lsb-release" ]; then
    
    # change cloud config to preserve hostname, otherwise our UI cannot set it
    sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
fi
