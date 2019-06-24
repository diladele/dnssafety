# Install Dns Safety on Debian 9

The following steps show how to install DnsSafety filter on 64-bit Debian 9. It is recommended to download installation scripts mentioned on each step from our [GitHub repository](https://github.com/diladele/dnssafety/tree/master/scripts.debian9) (sub folder scripts.debian9). Just run them one by one as root. Please note, build for Debian 9 is experimental and not supported in production deployments.

## Step 1. Update

It is recommended to update the system prior to installation. Run `bash 01_update.sh` in the console.

``` bash
#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# update, upgrade and reboot
apt update && apt -y upgrade && reboot
```


## Step 2. Install

Run `bash 02_dnssafety.sh` in the console to install the latest stable version of Dns Safety. Note the `/opt/dnssafety/bin/dsdnsd` daemon runs as standard `daemon` user in Linux.

``` bash
#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.10.0"
MINOR="1EC4"
ARCH="amd64"

# download
wget http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/$ARCH/release/debian9/dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# relabel folder
chown -R daemon:daemon /opt/dnssafety
```


## Step 3. Integrate

Finally, to integrate Dns Safety filter with the system run `bash 03_integrate.sh`. The script is simple, it just restarts the `dsdnsd` daemon.

``` bash
#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# recreate default /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# and restart dns safety dns server
systemctl restart dsdnsd
```

Reboot your server now to see that everything comes back to life correctly after it.