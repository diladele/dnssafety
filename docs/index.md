# DNS Safety Filter Admin Guide

[DNS Safety](https://www.dnssafety.io/) Filter is a DNS forwarding server (like dnsmasq) with extensive filtering capabilities. It allows administrator to filter access to domain names by categories, easily block access to user specified domains and provides different access policies for different groups of machines in your network.

DNS Safety Filter is supposed to be deployed as primary DNS server in your local network and can forward DNS requests to your ISP's DNS server, Google Public DNS, OpenDNS and other third party DNS providers. Internal DNS requests can be forwarded to internal DNS servers (for example Active Directory domain controllers).

The filter can be easily managed from full featured Web UI deployed on Ubuntu 18 LTS. Other operating systems might be supported too in the near future.

## Available Builds

Latest version 0.10.0.1EC4, built on June 21, 2019.

## Deploy as Virtual Appliance

* Fully configured [virtual appliance for VMware](http://packages.diladele.com/dnssafety/0.10.0.1EC4/va/ubuntu18/dnssafety.zip) ready to be deployed on VMware ESXi, vSphere, Workstation, Fusion or any other platform supporting OVA standard. Contains full featured Admin UI. Recommended way of deployment and usage of the product.
* The same virtual appliance is also available from [Microsoft Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/diladele.dnsfilter), ready to be deployed in your Microsoft Azure virtual infrastructure.

## Deploy on Your Own Hardware

If needed, the application can also be easily deployed on your own hardware servers.

* [Ubuntu 18.04 LTS](/install/ubuntu18/dns/). Recommended and supported way of deployment.
* [Debian 9](/install/debian9/).
* [FreeBSD 11](/install/freebsd11/).
* [pfSense 2.4](/install/pfsense/).

