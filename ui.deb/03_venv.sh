#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install various required python packages from the system repo
apt install -y python3-dev libjpeg-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev libatlas-base-dev g++

# install different command on debian 12 or ubuntu
if [ -f "/etc/lsb-release" ]; then
   apt install -y python3.8-venv
else
   apt install -y python3.11-venv python3-openssl
fi

# create a virtual environment in the /opt/dnssafety-ui folder
python3 -m venv /opt/dnssafety-ui/env

# install required packages into virtual environment
/opt/dnssafety-ui/env/bin/pip3 install -r /opt/dnssafety-ui/var/console/requirements.txt

# sync ui and actual files in disk (note UI does not manage network by default)
# sudo -u proxy /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --core
# sudo -u websafety /opt/websafety-ui/env/bin/python3 /opt/websafety-ui/var/console/generate.py --ui

## ???
# let UI of Dns Safety manage the network ONLY on amd64 based Debian 11 or Ubuntu 20, on RPI it is left as not managed
#if [ "$ARCH" != "armhf" ]; then
#    sudo -u daemon python3 /opt/dnssafety-ui/var/console/utils.py --network=$OSNAME    
#fi

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
