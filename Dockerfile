FROM resin/rpi-raspbian:wheezy
RUN apt-get -q update && apt-get install -yq dnsmasq syslinux-common freeipmi ipmitool openipmi && mkdir /tftp && cp /usr/lib/syslinux/pxelinux.0 /tftp
RUN cd /tftp ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz

CMD ["cat"]