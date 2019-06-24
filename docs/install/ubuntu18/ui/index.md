# Part 2: Install Admin UI for DNS Safety

!!! note
    Please, if possible always prefer to use the [fully configured virtual appliance](https://dnssafety.io/download.html) on your own VMware vSphere/ESXi infractucture or in [Microsoft Azure](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/diladele.dnsfilter). Moving on to the new version of Dns Safety will be so much easier!

Having installed the Dns Safety itself on Ubuntu 18.04 we now continue with installation of Admin UI. Remember we are using the installation scripts from our [GitHub repository](https://github.com/diladele/dnssafety/tree/master/scripts.ui) (look for subfolder named scripts.ui). Just run the scripts one by one as root.

Note, all this is already done in Virtual Appliance, you just need to download it from our site and run in VMware ESXi/vSphere, Microsoft Hyper-V or Microsoft Azure.

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

# update and upgrade
apt update && apt -y upgrade

# change cloud config to preserve hostname, otherwise our UI cannot set it
sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
```

## Step 2. Install Apache

Admin UI for Dns Safety is built up using Python Django and requires Apache web server to run. Run `bash 02_apache.sh` in the console to install the requirements.

``` bash
#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install pip3 and other python modules, ldap/sasl (we need it for python ldap module)
apt -y install python3-pip python3-dev libjpeg-dev zlib1g-dev libldap2-dev libsasl2-dev libssl-dev

# install django and all other modules
pip3 install django==2.1.2
pip3 install pytz
pip3 install tld
pip3 install requests
pip3 install pandas
pip3 install PyYAML
pip3 install psutil

# there are some bugs in Ubuntu 18 and Python3 environment concerning the LDAP module,
# so we fix them by removing obsolete ldap modules and reinstalling the correct one
pip3 uninstall ldap
pip3 uninstall ldap3
pip3 uninstall python-ldap

# ok this one is fine
pip3 install python-ldap

# now install reportlab
pip3 install reportlab==3.4.0

# install apache and mod_wsgi and some other useful programs
apt -y install apache2 libapache2-mod-wsgi-py3 htop mc

# install kerberos client libraries
export DEBIAN_FRONTEND=noninteractive 
apt -y install krb5-user
```

## Step 3. Install Admin UI

Run `bash 03_dnssafety-ui.sh` in the console to install the Admin UI package. Note that the exact version of Admin UI does not correspond to exact version of Dns Safety filtering server. That is normal as we use two different git repositories for development. Admin UI is updated more frequently than Dns Safety code itself.

``` bash
#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# default arc
MAJOR="0.10.0"
MINOR="8B76"
ARCH="amd64"

# download
wget http://packages.diladele.com/dnssafety-ui/$MAJOR.$MINOR/$ARCH/release/ubuntu18/dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# install
dpkg --install dnssafety-ui-$MAJOR.${MINOR}_$ARCH.deb

# let UI of Dns Safety manage the network
sudo -u daemon python3 /opt/dnssafety-ui/var/console/utils.py --network=ubuntu18

# relabel folder
chown -R daemon:daemon /opt/dnssafety-ui
```

## Step 3. Integrate

Finally, to integrate Admin UI with Apache run `bash 04_integrate.sh`. 

``` bash
#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# integrate with apache
a2dissite 000-default
a2ensite dnssafety-ui

# and restart all daemons
service apache2 restart
```

Reboot your server now to see that everything comes back to life correctly after it. After reboot, open your browser and navigate to the IP address of the server, you should see the login page of the UI.

![Login Page](login.png?raw=true "Login to Admin UI")

Note, if you just need to see the application in action, it is much easier to use the virtual appliance for VMware or Microsoft Azure, links are available from [Download section of our site](https://www.dnssafety.io/download.html).