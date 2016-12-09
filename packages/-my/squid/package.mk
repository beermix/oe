PKG_NAME="squid"
#PKG_VERSION="3.5.20"
#PKG_URL="http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.20.tar.xz"
PKG_VERSION="4.0.15"
PKG_URL="http://www.squid-cache.org/Versions/v4/squid-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain fuse netbsd-curses openssl glib libcap libnetfilter_conntrack"

PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="squid_cv_gnu_atomics=yes \
                           --enable-static \
			   --enable-async-io=8 \
			   --enable-linux-netfilter \
                           --disable-optimizations \
                           --sysconfdir=/storage/.config/squid \
                           --datarootdir=/storage/.config/squid \
                           --libdir=/storage/.config/squid \
                           --enable-auth-digest \
                           --enable-auth-basic="getpwnam,NCSA,SMB,SMB_LM,RADIUS" \
                           --enable-epoll \
                           --enable-removal-policies="lru,heap" \
                           --disable-strict-error-checking \
                           --disable-silent-rules \
                           --with-openssl \
                           --with-expat \
                           --without-libxml2 \
                           --without-nettle \
                           --without-gnutls \
                           --with-libcap \
                           --enable-loadable-modules \
                           --disable-htcp \
                           --disable-eui  \
                           --enable-snmp \
                           --disable-select \
                           --disable-epoll \
                           --disable-http-violations \
                           --disable-db"
                           
post_makeinstall_target() {
  rm -rf $INSTALL/storage
}