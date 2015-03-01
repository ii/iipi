FROM resin/rpi-raspbian:wheezy
RUN apt-get -q update && apt-get install -yq dnsmasq syslinux-common freeipmi ipmitool openipmi wget dropbear tmux emacs lsof sipcalc git-core build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev automake libssh-dev cmake ruby && apt-get clean && rm -rf /var/lib/apt/lists/* && mkdir /tftp && cp /usr/lib/syslinux/pxelinux.0 /tftp 
RUN cd /tftp ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz
COPY etc/default/* /etc/default/
COPY .ssh /root/.ssh
COPY start.sh /
COPY pxe-cloud-config.yml /usr/share/mini-httpd/html/
RUN cd /root ; git clone https://github.com/nviennot/tmate ; cd tmate ; ./autogen.sh && ./configure && make install
RUN cat /proc/cpuinfo ;  uname -a ; free -m ; df -H ; ip addr ; ip route
# RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N '' ; tmate -S /tmp/tmate.sock new-session -d ; tmate -S /tmp/tmate.sock wait tmate-ready ; tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' ; cat /dev/random
CMD ["bash", "/start.sh"]