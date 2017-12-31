PKG_NAME="squid"
PKG_VERSION="3.5.23"
PKG_URL="http://www.squid-cache.org/Versions/v3/3.5/squid-$PKG_VERSION.tar.xz"
#PKG_VERSION="4.0.15"
#PKG_URL="http://www.squid-cache.org/Versions/v4/squid-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain fuse ncurses openssl glib libcap libnetfilter_conntrack"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="squid_cv_gnu_atomics=no \
                           --enable-static \
                           --enable-async-io=8 \
                           --enable-linux-netfilter \
                           --enable-optimizations \
                           --enable-auth-digest \
                           --enable-auth-basic="getpwnam,NCSA,SMB,SMB_LM,RADIUS" \
                           --enable-epoll \
                           --enable-removal-policies="lru,heap" \
                           --disable-strict-error-checking \
                           --enable-silent-rules \
                           --with-openssl \
                           --with-expat \
                           --without-libxml2 \
                           --without-nettle \
                           --without-gnutls \
                           --with-libcap \
                           --disable-loadable-modules \
                           --disable-htcp \
                           --disable-eui  \
                           --enable-snmp \
                           --disable-select \
                           --disable-epoll \
                           --disable-http-violations \
                           --disable-db \
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
                           --localedir=/storage/.config/squid"
                           
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}