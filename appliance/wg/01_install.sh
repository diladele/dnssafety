#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# update, upgrade and install wireguard
apt update && apt -y upgrade && apt -y install wireguard iptables