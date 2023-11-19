#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# in debian 12 on azure systemd resolver is active, we need to disable it
# failure to do so will mean dsdnsd daemon will not be able to start as
# port 53 would be taken by the systemd resolver
systemctl disable --now systemd-resolved
systemctl stop systemd-resolved

# copy the change password script to bin folder
cp chpass_aws.sh /opt/dnssafety/bin/

# make it executable
chmod +x /opt/dnssafety/bin/chpass_aws.sh

#  create systemd service that runs exactly once
cp chpass_aws.service /etc/systemd/system/chpass_aws.service

# enable it
systemctl enable chpass_aws.service
systemctl daemon-reload

# disable network management from Admin UI on AWS
patch /opt/dnssafety-ui/var/console/node/models.py < models.py.patch
