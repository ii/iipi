####

* Install bananian to sd card
https://www.bananian.org/download

* Install tmate from src
http://tmate.io/

* Install rvm /  ruby 2.2.1

* Install wimlib

wget https://launchpad.net/~nilarimogard/+archive/ubuntu/webupd8/+files/wimlib_1.8.0-1~webupd8~utopic.tar.xz
tar xvf wimlib*xz
apt-get install libfuse-dev debhelper libfuse-dev libxml2-dev ntfs-3g-dev dh-autoreconf libselinux-dev attr-dev attr doxygen
cd wimlib-*
dpkg-buildpackage -uc -us



* Install dnsmasq

apt-get install dnsmasq

IP=$(ip -o -f inet addr show dev eth0 scope global | perl -nle 's:inet (\S+)/:print $1:e')
CIDR=$(ip -o -f inet addr show dev eth0 scope global | perl -nle 's:inet \S+/(\S+):print $1:e')
MASK=$(sipcalc eth0 | perl -nle 's:Network mask\s+[-]\s(\S+):print $1:e')
#case $CIDR in
#24) MASQ=255.255.255.0 ;;
#16) MASK=255.255.0.0 ;;
#8) MASK=255.0.0.0 ;;
#esac

cat <<EOF>/etc/dnsmasq.d/proxy.conf
# DO NOT EDIT, this file is dynamically created from /etc/default/dnsmasq
interface=eth0
dhcp-range=${IP},proxy,${MASK}
port=0 #no dns
log-dhcp #for debugging
#bind-dynamic # we don't want to run on all interfaces
# get a file loaded via pxe
dhcp-boot=tag:ipxe,hanlon.ipxe,${IP},${IP}
dhcp-boot=tag:!ipxe,undionly.kpxe,${IP},${IP}
dhcp-boot=undionly.kpxe,${IP},${IP}
dhcp-userclass=set:ipxe,iPXE
# Old school pxe service tftp server/file to load
pxe-prompt="Press F8 for boot menu", 3
pxe-service=X86PC, "Boot from network", pxelinux, ${IP}
pxe-service=X86PC, "Boot from local hard disk", 0, ${IP}
#dhcp-option-force=224,${IP} # hanlon server
#dhcp-option-force=225,8026 # hanlon port
#dhcp-option-force=226,http://${IP}:8026/ # hanlon url
enable-tftp
tftp-root=/home/tftp
EOF

* Install hanlon

apt-get install freeipmi-tools ipmitool dnsmasq



git clone
cd /home/hanlon
rvm use 2.1.1@hanlon
bundle install --system

{"hanlon_static_path": "'$HANLON_STATIC_PATH'", "hanlon_subnets": "'$HANLON_SUBNETS'", "hanlon_server": "'$DOCKER_HOST'", "persist_host": "'$MONGO_PORT_27017_TCP_ADDR'"}' )

hanlon_init creates config files


hanlon_server.conf

```
persist_mode: :memory
hnl_mk_boot_debug_level: Logger::DEBUG
hnl_mk_boot_kernel_args: 'hanlon.ip=1.1.1.8 hanlon.port=8026'
ipmi_password: 'ADMIN'
ipmi_username: 'ADMIN'
ipmi_utility: ''
image_path: "/home/hanlon/image"
ipmi_utility: ipmitool
# DEPRECATED: use hnl_mk_boot_kernel_args instead!
# used to set the Microkernel boot debug level; valid values are
# either the empty string (the default), "debug", or "quiet"
sui_allow_access: 'true'
sui_mount_path: "/docs"
```

