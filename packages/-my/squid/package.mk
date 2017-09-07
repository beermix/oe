PKG_NAME="squid"
PKG_VERSION="4.0.20"
PKG_URL="http://www.squid-cache.org/Versions/v4/squid-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain fuse ncurses openssl glib libcap libnetfilter_conntrack"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-pidfile=/var/run/squid.pid \
                           --sysconfdir=/storage/.config/squid/ \
                           --datadir=/storage/.config/squid \
                           --libdir=/storage/.config/squid \
                           --libexecdir=/storage/.config/squid \
                           --sharedstatedir=/storage/.config/squid \
                           --localstatedir=/storage/.config/squid \
                           --includedir=/storage/.config/squid \
                           --oldincludedir=/storage/.config/squid \
                           --datarootdir=/storage/.config/squid \
                           --infodir=/storage/.config/squid \     
                           --localedir=/storage/.config/squid \
                           --with-openssl=$SYSROOT_PREFIX/usr \
                           --enable-linux-netfilter \
                           --enable-ident-lookups \
                           --enable-useragent-log \
                           --enable-cache-digests \
                           --enable-referer-log \
                           --enable-htcp \
                           --enable-carp \
                           --enable-epoll \
                           --with-large-files \
                           --with-default-user=proxy \
                           --enable-async-io \
                           --enable-truncate \
                           --enable-icap-client \
                           --enable-ssl-crtd \
                           --disable-arch-native \
                           --disable-strict-error-checking \
                           --enable-wccpv2"
                           
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}