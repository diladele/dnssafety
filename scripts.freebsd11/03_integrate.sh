#!/bin/csh

# relabel folder
chown -R dnssafety:dnssafety /opt/dnssafety

# restart all daemons
service dsdnsd restart
