# Part 1: Install DNS Safety on Ubuntu 18.04

!!! note
    Please, if possible always prefer to use the [fully configured virtual appliance](https://dnssafety.io/download.html) on your own VMware vSphere/ESXi infractucture or in [Microsoft Azure](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/diladele.dnsfilter). Moving on to the new version of Dns Safety will be so much easier!


The following steps show how to install core DNS Safety filter on 64-bit Ubuntu Server 18.04 LTS. It is recommended to download installation scripts mentioned on each step from our [GitHub repository](https://github.com/diladele/dnssafety/tree/master/scripts.ubuntu18) (look for subfolder named scripts.ubuntu18). Just run the scripts one by one as root.

## Step 1. Update System

It is recommended to update the system prior to installation. Run `bash 01_update.sh` in the console.

``` bash
#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# add universe repo
add-apt-repository universe

# update, upgrade and reboot
apt update && apt -y upgrade && reboot
```

## Step 2. Install DNS Server

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
wget http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/$ARCH/release/ubuntu18/dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-$MAJOR.${MINOR}_$ARCH.deb

# relabel folder
chown -R daemon:daemon /opt/dnssafety
```

## Step 3. Integrate

To integrate Dns Safety filter with the system run `bash 03_integrate.sh`. Note how we disable standard systemd-resolver here and place our own DNS server into the system instead.

``` bash
#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# disable and remove systemd resolver
systemctl disable systemd-resolved
systemctl stop systemd-resolved

# resolv.conf is a link under systemd resolver
ls -lh /etc/resolv.conf 

# remove it
rm /etc/resolv.conf

# recreate default one
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# and restart dns safety dns server
systemctl restart dsdnsd
```

Now continue on to part 2 to install the Admin UI for Dns Safety.