#!/bin/bash
export IPMI_PASSWD=${IPMI_PASSWD:=ADMIN}
export IPMI_USER=${IPMI_USER:=ADMIN}
cat <<EOF >/etc/freeipmi/freeipmi.conf
username $IPMI_USER
password $IPMI_PASSWD
EOF
/etc/init.d/dnsmasq start
/etc/init.d/mini-httpd start
# start tmate
# ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > /usr/share/mini-httpd/html/tmate
#Set the root password
export PASSWD=${PASSWD:=root}
echo "root:$PASSWD" | chpasswd
#Spawn dropbear
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
dropbear -E -F
