PKG_NAME="squid"
PKG_VERSION="3.5.24"
PKG_URL="http://www.squid-cache.org/Versions/v3/3.5/squid-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain fuse netbsd-curses openssl glib libcap libnetfilter_conntrack"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=7

PKG_CONFIGURE_OPTS_TARGET="squid_cv_gnu_atomics=yes \ 
			      ac_cv_epoll_works=yes \
			      ac_cv_func_setresuid=yes \
			      ac_cv_func_va_copy=yes \
			      ac_cv_func___va_copy=yes \
			      ac_cv_func_strnstr=no \
			      ac_cv_have_squid=yes \
                           --with-pidfile=/var/run/squid.pid \
                           --enable-auth \
                           --enable-auth-basic \
                           --enable-auth-ntlm \
                           --enable-auth-digest \
                           --enable-auth-negotiate \
                           --enable-removal-policies="lru,heap" \
                           --enable-storeio="aufs,ufs,diskd" \
                           --enable-delay-pools \
                           --enable-arp-acl \
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
                           --enable-wccpv2 \
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
                           
post_makeinstall_target() {
  rm -rf $INSTALL/storage
}