#!/bin/bash
#
# update root password in the Dns Safety to a random value
# required for vm publication in the AWS Cloud Marketplace
#

FLAG_FILE="/opt/dnssafety/etc/password_reset.flag"

if [ -f $FLAG_FILE ]; then

    echo "Flag file $FLAG_FILE exists, thus root password changed from the built-in"
    echo "Password value at least once, no need to do anything, skipping..."
    
else

    # we are using instance id as new password
    NEWPASW=`curl http://169.254.169.254/latest/meta-data/instance-id`

    # update the password in the database 
    sudo -u daemon /opt/dnssafety-ui/env/bin/python3 /opt/dnssafety-ui/var/console/reset_password.py --password=$NEWPASW

    # change the template too so that user knows what shall be used as password
    sudo -u daemon sed -i "s/Passw0rd/InstanceID/g" /opt/dnssafety-ui/var/console/frame/templates/login.html

    # raise the updated password flag so that we do not regenerate it next reboot
    echo "Do NOT remove this file!" >  "$FLAG_FILE"
    echo "Do NOT remove this file!" >> "$FLAG_FILE"
    echo "Do NOT remove this file!" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"

    echo "If you remove this flag file, the /etc/systemd/service/chpass_aws.service service "  >> "$FLAG_FILE"
    echo "will automatically call /opt/dnssafety/bin/chpass_aws.sh file that will reset"       >> "$FLAG_FILE"
    echo "the password of the root user in Dns Safety UI to ID of this instance."              >> "$FLAG_FILE"
    echo "This is required for VMs generated from AMI template in Amazon AWS."                 >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"
    echo "" >> "$FLAG_FILE"

    echo "It is recommended to run \"systemctl disable chpass_aws.service\" to disable this functionality." >> "$FLAG_FILE"
    
fi
