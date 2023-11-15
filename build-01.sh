#!/bin/bash

# check we are root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default os
OSNAME="debian12"
if [ -f "/etc/lsb-release" ]; then
    OSNAME="ubuntu22"
fi

# run first step
pushd core.$OSNAME && bash 01_update.sh && popd
