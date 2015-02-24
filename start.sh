#!/bin/bash
export PASSWD=${PASSWD:=root}
#Set the root password
echo "root:$PASSWD" | chpasswd
/etc/init.d/dnsmasq start
#Spawn dropbear
dropbear -E -F
