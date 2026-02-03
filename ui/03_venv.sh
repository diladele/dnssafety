#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install various required python packages from the system repo
apt install -y python3-dev libjpeg-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev g++ patch
apt install -y python3.13-venv python3-openssl

# create a virtual environment in the /opt/dnssafety-ui folder
python3 -m venv /opt/dnssafety-ui/env

# install required packages into virtual environment
/opt/dnssafety-ui/env/bin/pip3 install -r /opt/dnssafety-ui/var/console/requirements.txt

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
