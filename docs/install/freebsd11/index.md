# Install Dns Safety on FreeBSD 11

The following steps show how to install DNS Safety filter on 64-bit FreeBSD 11. It is recommended to download installation scripts mentioned on each step from our [GitHub repository](https://github.com/diladele/dnssafety/tree/master/scripts.freebsd11) (sub folder scripts.freebsd11). Just run them one by one as root. Please note, build for FreeBSD 11 is experimental and not supported in production deployments.

## Step 1. Update

It is recommended to update the system prior to installation. Run `sh 01_update.sh` in the console.

``` bash
#!/bin/csh

# update the system
freebsd-update fetch
freebsd-update install

# bootstrap pkg
env ASSUME_ALWAYS_YES=YES pkg bootstrap

# and reboot
reboot
```

## Step 2. Install

The following script installs the latest stable version of Dns Safety. Note the `/opt/dnssafety/bin/dsdnsd` daemon runs as standard `bind` user in FreeBSD.

``` bash
#!/bin/csh

# setup some configuration variables
ARCH=`uname -m`
MAJOR=0.10.0
MINOR=1EC4

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
```

## Step 3. Integrate

Dns Safety Filter runs as `bind` user by default. This user is not privileged, thus it cannot bind to port 53 as required by any normal DNS Server. We will work around this issue by modifying the system to allow `bind` user to bind to DNS port.

Note, that the following discussion is based on instructions [here](https://kb.isc.org/docs/aa-00621) and [here](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/mac-policies.html).

First, modify your `/boot/loader.conf` to load the `mac_portacl_load` kernel module upon start.

    # /boot/loader.conf:
    mac_portacl_load="YES"

Then change your `/etc/sysctl.conf` to contain the following values. Note how we reuse the user id `53` of the standard system `bind` user in the ACL rule.

    # /etc/sysctl.conf:  
    net.inet.ip.portrange.reservedlow=0
    net.inet.ip.portrange.reservedhigh=0
    security.mac.portacl.port_high=1023
    security.mac.portacl.suser_exempt=1
    security.mac.portacl.rules=uid:53:tcp:53,uid:53:udp:53

Finally, to integrate Dns Safety filter into the system run `sh 03_integrate.sh`. Note how we relabel the installation folder to `bind` user.

``` bash
#!/bin/csh

# finally relabel folder (note we reuse the bind user here!)
chown -R bind:bind /opt/dnssafety

# restart all daemons
service dsdnsd restart
```

Reboot your server now to see that everything comes back to life correctly after it.
