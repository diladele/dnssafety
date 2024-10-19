#!/bin/bash

CPUNUM=`cat /proc/cpuinfo | grep processor | wc -l`
RAMNFO=`free -mh | grep Mem: | awk {'print $2, "total,", $4, "free" '}`
DISKSZ=`df -h | grep "/$" | awk {'print $2, "total,", $4, "free" '}`
VA_VER=`/bin/bash /opt/dnssafety/bin/version.sh`

# some string manupulation magic
OSINFO_TMP1=`cat /etc/os-release | grep ^VERSION=`
OSINFO_NAME=${OSINFO_TMP1#VERSION=}
OSINFO_NAME=${OSINFO_NAME#\"}
OSINFO_NAME=${OSINFO_NAME%\"}

OSINFO_TMP2=`cat /etc/os-release | grep ^NAME=`
OSINFO_DIST=${OSINFO_TMP2#NAME=}
OSINFO_DIST=${OSINFO_DIST#\"}
OSINFO_DIST=${OSINFO_DIST%\"}

echo "Welcome to DNS Safety virtual appliance!"
echo 
echo "Operating System    $OSINFO_DIST, $OSINFO_NAME"
echo "System Kernel       \\r"
echo "System Arch         \\m"
echo "RAM Available       $RAMNFO"
echo "CPU Count           $CPUNUM"
echo "Hard Disk Size      $DISKSZ"
echo
echo "Appliance Version   $VA_VER"
echo "Default Username    root"
echo "Default Password    Passw0rd"
echo "Installation Dirs   /opt/dnssafety and /opt/dnssafety-ui"
echo 
echo "To use this Virtual Appliance as DNS server - adjust your router settings"
echo "to use IP address of this box \\4 as a DNS server."
echo 
echo "Manage filtering settings using Admin UI from your browser at http://\\4:8000/"
echo "Note the port 8000, ports 80 and 443 are used to show Access Denied page!"
echo
