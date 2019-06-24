# Install Dns Safety on CentOS 7

The following steps show how to install DNS Safety filter on 64-bit CentOS 7. It is recommended to download installation scripts mentioned on each step from our [GitHub repository](https://github.com/diladele/dnssafety/tree/master/scripts.centos7) (sub folder scripts.centos7). Just run them one by one as root. Please note, build for CentOS 7 is experimental and not supported in production deployments.

## Step 1. Update

It is recommended to update the system prior to installation. Run `bash 01_update.sh` in the console. Note how we disable SELinux module to proceed with installation. Dns Safety is only tested with disabled SELinux, so if you need it enabled, please adjust SELinux rules self as required.

``` bash
#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# enable epel repository and update
yum -y install epel-release && yum -y update

# disable selinux
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

# and reboot
reboot
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

# get latest build
curl -O http://packages.diladele.com/dnssafety/$MAJOR.$MINOR/amd64/release/centos7/dnssafety-${MAJOR}-${MINOR}.x86_64.rpm

# install it
yum -y --nogpgcheck localinstall dnssafety-${MAJOR}-${MINOR}.x86_64.rpm
  
# relabel folder
chown -R daemon:daemon /opt/dnssafety
```

## Step 3. Integrate

Finally, to integrate Dns Safety filter with the system run `bash 03_integrate.sh`. The script is simple, it just restarts the `dsdnsd` daemon.

``` bash
#!/bin/bash

# integration should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# allow connections to 53 port both UDP and TCP
firewall-cmd --permanent --zone=public --add-port=53/tcp
firewall-cmd --permanent --zone=public --add-port=53/udp
firewall-cmd --reload

# restart dsdnsd just in case
systemctl restart dsdnsd
```

Reboot your server now to see that everything comes back to life correctly after it.