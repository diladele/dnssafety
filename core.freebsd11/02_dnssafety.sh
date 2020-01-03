#!/bin/csh

# setup some configuration variables
ARCH=`uname -m`
MAJOR=0.15.0
MINOR=D014

# get latest version of dns safety
fetch http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/$ARCH/release/freebsd11/dnssafety-$MAJOR-$ARCH.txz

# and install it
env ASSUME_ALWAYS_YES=YES pkg install -y dnssafety-$MAJOR-$ARCH.txz

# autostart DNS server
grep -e '^\s*dsdnsd_enable\s*=\s*\"YES\"\s*$' /etc/rc.conf
if [ $? -ne 0 ]; then
    echo "dsdnsd_enable=\"YES\"" >> /etc/rc.conf
fi

# relabel folder (note we reuse the bind user here!)
chown -R bind:bind /opt/dnssafety