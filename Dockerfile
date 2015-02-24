FROM resin/rpi-raspbian:wheezy
RUN apt-get -q update && apt-get install -yq dnsmasq syslinux-common freeipmi ipmitool openipmi wget dropbear && apt-get clean && rm -rf /var/lib/apt/lists/* && mkdir /tftp && cp /usr/lib/syslinux/pxelinux.0 /tftp ; cd /tftp ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz
COPY . /app

CMD ["bash", "/app/start.sh"]