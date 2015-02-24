#!/bin/bash
export PASSWD=${PASSWD:=root}
export IPMI_PASSWD=${IPMI_PASSWD:=ADMIN}
export IPMI_USER=${IPMI_USER:=ADMIN}
cat <<EOF >/etc/freeipmi/freeipmi.conf
username $IPMI_USER
password $IPMI_PASSWD
EOF
#Set the root password
echo "root:$PASSWD" | chpasswd
/etc/init.d/dnsmasq start
#Spawn dropbear
dropbear -E -F
