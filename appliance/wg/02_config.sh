#!/bin/bash

# update should be done as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# generate wireguard configuration
tee /etc/wireguard/wg0.conf <<END
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = $(wg genkey)
PostUp = sysctl net.ipv4.ip_forward=1
PostUp = iptables -A FORWARD -i eth0 -o %i -j ACCEPT
PostUp = iptables -A FORWARD -i %i -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = sysctl net.ipv4.ip_forward=0
PostDown = iptables -D FORWARD -i eth0 -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
END

# start wireguard at boot
systemctl start wg-quick@wg0 
systemctl enable wg-quick@wg0

# create the client folder if it does not exist already
mkdir -p /etc/wireguard/clients 

# and set its permissions
chmod go= /etc/wireguard/clients
