FROM resin/rpi-raspbian:wheezy
RUN apt-get -q update && apt-get install -yq dnsmasq syslinux-common freeipmi ipmitool openipmi wget dropbear tmux emacs lsof sipcalc && apt-get clean && rm -rf /var/lib/apt/lists/* && mkdir /tftp && cp /usr/lib/syslinux/pxelinux.0 /tftp 
RUN cd /tftp ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz
COPY etc/default/* /etc/default/
COPY .ssh /root/.ssh
COPY start.sh /
COPY pxe-cloud-config.yml /usr/share/mini-httpd/html
RUN cat /proc/cpuinfo ;  uname -a ; free -m ; df -H ; ip addr ; ip route
CMD ["bash", "/start.sh"]