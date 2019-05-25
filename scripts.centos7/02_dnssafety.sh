#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.8.0"
MINOR="828D"

# get latest build
curl -O http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/amd64/release/centos7/dnssafety-${MAJOR}-${MINOR}.x86_64.rpm

# install it
yum -y --nogpgcheck localinstall dnssafety-${MAJOR}-${MINOR}.x86_64.rpm
  
# relabel folder
chown -R daemon:daemon /opt/dnssafety
