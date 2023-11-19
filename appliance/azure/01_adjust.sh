#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# in debian 12 on azure systemd resolver is active, we need to disable it
# failure to do so will mean dsdnsd daemon will not be able to start as
# port 53 would be taken by the systemd resolver
systemctl disable --now systemd-resolved
systemctl stop systemd-resolved

#
# re-enable extensions https://wiki.debian.org/Cloud/MicrosoftAzure
#
sed -i -e 's/^Extensions\.Enabled=.*$/Extensions.Enabled=y/' /etc/waagent.conf
sed -i -e 's/^AutoUpdate\.Enabled=.*$/AutoUpdate.Enabled=y/' /etc/waagent.conf

# disable network management from Admin UI on Azure
patch /opt/dnssafety-ui/var/console/node/models.py < models.py.patch

#
# enable login with older ssh keys (required for Azure Certification Tools)
#
cat <<EOT >> /etc/ssh/sshd_config.d/51-dnssafety.conf
HostKeyAlgorithms=ssh-rsa,ssh-rsa-cert-v01@openssh.com
PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-rsa-cert-v01@openssh.com
EOT

# the Azure deployment insists on this
sed -i 's/ClientAliveInterval 120/ClientAliveInterval 180/g' /etc/ssh/sshd_config
