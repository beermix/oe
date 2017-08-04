PKG_NAME="unbound"
PKG_VERSION="f9929f6"
#PKG_URL="https://fossies.org/linux/misc/dns/unbound-1.6.2.tar.xz"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-dsa \
			      --disable-gost \
			      --enable-allsymbols \
			      --disable-rpath \
			      --enable-pie \
			      --enable-relro-now \
			      --disable-shared \
			      --enable-systemd \
			      --with-pidfile=/var/run/unbound.pid \
			      --with-libevent=$SYSROOT_PREFIX/usr \
			      --with-libsodium=$SYSROOT_PREFIX/usr \
			      --with-libexpat=$SYSROOT_PREFIX/usr \
			      --with-ssl=$SYSROOT_PREFIX/usr"
#		
#post_makeinstall_target() {
#  rm -rf $INSTALL/storage
#}
