PKG_NAME="inetutils"
PKG_VERSION="1.9.4"
PKG_URL="http://ftpmirror.gnu.org/inetutils/inetutils-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libcap" 
PKG_DEPENDS_HOST="libcap:host" 
PKG_SECTION="python/system"

PKG_CONFIGURE_OPTS_TARGET="--disable-ipv6 \
			      --without-wrap \
			      --with-pam \
			      --enable-ftp \
			      --enable-ftpd \
			      --enable-telnet \
			      --enable-telnetd \
			      --enable-talk \
			      --enable-talkd \
			      --enable-rlogin\
			      --enable-rlogind \
			      --enable-rsh \
			      --enable-rshd \
			      --enable-rcp \
			      --enable-hostname \
			      --enable-dnsdomainname \
			      --disable-rexec \
			      --disable-rexecd \
			      --disable-tftp \
			      --disable-tftpd \
			      --disable-ping \
			      --disable-ping6 \
			      --disable-logger \
			      --disable-syslogd \
			      --disable-inetd \
			      --disable-whois \
			      --disable-uucpd \
			      --disable-ifconfig \
			      --disable-traceroute"
			      
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"