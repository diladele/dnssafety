#!/bin/csh

#
# we need to allow dnssafety user to bind to 53 port (TCP, UDP)
# see:
#     https://kb.isc.org/docs/aa-00621
#     https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/mac-policies.html
#
#
# /boot/loader.conf:
# mac_portacl_load="YES"
#
# /etc/sysctl.conf:  
# net.inet.ip.portrange.reservedlow=0
# net.inet.ip.portrange.reservedhigh=0
# security.mac.portacl.port_high=1023
# security.mac.portacl.suser_exempt=1
# security.mac.portacl.rules=uid:53:tcp:53,uid:53:udp:53
#
# finally relabel folder (note we reuse the bind user here!)
chown -R bind:bind /opt/dnssafety

# restart all daemons
service dsdnsd restart
