FROM resin/rpi-raspbian:wheezy

MAINTAINER Chris McClimans <hh@ii.org.nz>

RUN echo 'deb http://httpredir.debian.org/debian unstable main non-free contrib' >> /etc/apt/sources.list \
	&& echo 'Package: *' >> /etc/apt/preferences.d/pin \
	&& echo 'Pin: release a=stable' >> /etc/apt/preferences.d/pin \
	&& echo 'Pin-Priority: 1000' >> /etc/apt/preferences.d/pin \
	&& echo '' >> /etc/apt/preferences.d/pin \
	&& echo 'Package: *' >> /etc/apt/preferences.d/pin \
	&& echo 'Pin: release a=stable' >> /etc/apt/preferences.d/pin \
	&& echo 'Pin-Priority: 1000' >> /etc/apt/preferences.d/pin

RUN apt-get update -y \
  && apt-get install -y debian-keyring debian-archive-keyring apt-utils

# Install the required dependencies
RUN apt-get install -y libxml2 gettext libfuse-dev libattr1-dev \
    git build-essential libssl-dev p7zip-full fuseiso ipmitool libbz2-dev \
    autotools-dev autoconf

RUN mkdir -p /usr/src/wimlib-code \
	&& mkdir -p /home/hanlon \
	&& git clone git://wimlib.net/wimlib /usr/src/wimlib-code \
	&& cd /usr/src/wimlib-code \
	&& ./bootstrap \
	&& ./configure --without-ntfs-3g --prefix=/usr \
	&& make -j"$(nproc)" \
	&& make install \
	&& apt-get purge -y --auto-remove gettext \
	&& rm -Rf /usr/src/wimlib-code


RUN cd /home ; git clone https://github.com/csc/Hanlon.git hanlon
RUN echo "install: --no-rdoc --no-ri" > /etc/gemrc
RUN gem install bundle \
	&& cd /home/hanlon \
	&& bundle install --system

ENV LANG en_US.UTF-8
ENV WIMLIB_IMAGEX_USE_UTF8 true
ENV HANLON_WEB_PATH /home/hanlon/web

RUN apt-get -q update && apt-get install -yq dnsmasq syslinux-common freeipmi \
  openipmi wget dropbear tmux emacs lsof sipcalc git-core \
  build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev \
  automake libssh-dev cmake ruby mini-httpd openssh-server net-tools

RUN mkdir /tftp && cp /usr/lib/syslinux/pxelinux.0 /tftp

RUN apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN cd /tftp \
  ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz \
  ; wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz

COPY etc/default/* /etc/default/
COPY .ssh /root/.ssh
COPY start.sh /
COPY pxe-cloud-config.yml /usr/share/mini-httpd/html/
#RUN cd /root ; GIT_SSL_NO_VERIFY=true git clone https://github.com/nviennot/tmate ; cd tmate ; git checkout 1.8.10; ./autogen.sh && ./configure && make install ; ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
#RUN cat /proc/cpuinfo ;  uname -a ; free -m ; df -H
# ; ip addr ; ip route
#RUN tmate -S /tmp/tmate.sock new-session -d ; tmate -S /tmp/tmate.sock wait tmate-ready ; tmate -S /tmp/tmate.sock display -p '#{t
# mate_ssh}' ; cat /dev/random
CMD ["bash", "/start.sh"]