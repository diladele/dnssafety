#!/bin/csh

#
# we need to allow dnssafety user to bind to 53 port (TCP, UDP)
# see:
#     https://kb.isc.org/docs/aa-00621
#     https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/mac-policies.html
#
echo "IMPORTANT - MANUAL CHANGE REQUIRED!"
echo "IMPORTANT - MANUAL CHANGE REQUIRED!"
echo "IMPORTANT - MANUAL CHANGE REQUIRED!"
echo "IMPORTANT - MANUAL CHANGE REQUIRED!"
echo "IMPORTANT - MANUAL CHANGE REQUIRED!"
#
# /boot/loader.conf:
# mac_portacl_load="YES"
#
# /etc/sysctl.conf:  
# net.inet.ip.portrange.reservedlow=0
# net.inet.ip.portrange.reservedhigh=0
# security.mac.portacl.port_high=1023
# security.mac.portacl.suser_exempt=1
# security.mac.portacl.rules=uid:1005:tcp:53,uid:1005:udp:53
#
# NOTE!!! the 1005 is the uid of dnssafety user!
#
# relabel folder
chown -R dnssafety:dnssafety /opt/dnssafety

# restart all daemons
service dsdnsd restart
