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
# dropbear -E -F

./hanlon_init -j '{"hanlon_static_path": "'$HANLON_STATIC_PATH'", "hanlon_subnets": "'$HANLON_SUBNETS'", "hanlon_server": "'$DOCKER_HOST'", "persist_host": "'$MONGO_PORT_27017_TCP_ADDR'", "ipmi_utility": "ipmitool"}'
fi

cd ${HANLON_WEB_PATH}

PORT=`awk '/api_port/ {print $2}' config/hanlon_server.conf`
puma -p ${PORT} $@ 2>&1 | tee /tmp/puma.log
