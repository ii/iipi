#!/bin/bash
export IPMI_PASSWD=${IPMI_PASSWD:=ADMIN}
export IPMI_USER=${IPMI_USER:=ADMIN}
cat <<EOF >/etc/freeipmi/freeipmi.conf
username $IPMI_USER
password $IPMI_PASSWD
EOF
/etc/init.d/dnsmasq start
#Set the root password
export PASSWD=${PASSWD:=root}
echo "root:$PASSWD" | chpasswd
#Spawn dropbear
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
dropbear -E -F
