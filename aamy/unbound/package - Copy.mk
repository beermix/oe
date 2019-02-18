PKG_NAME="unbound"
PKG_VERSION="49eeb61"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium expat"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

#LTO_SUPPORT="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-dsa \
			      --disable-gost \
			      --enable-allsymbols \
			      --disable-rpath \
			      --disable-flto \
			      --enable-pie \
			      --enable-relro-now \
			      --disable-shared \
			      --enable-cachedb \
			      --enable-dnscrypt \
			      --disable-dnstap \
			      --enable-checking \
			      --enable-allsymbols \
			      --enable-systemd \
			      --sysconfdir=/storage/.config /
			      --with-pidfile=/var/run/unbound.pid \
			      --with-libevent=$SYSROOT_PREFIX/usr \
			      --with-libsodium=$SYSROOT_PREFIX/usr \
			      --with-libexpat=$SYSROOT_PREFIX/usr \
			      --with-ssl=$SYSROOT_PREFIX/usr"
		
post_makeinstall_target() {
  rm -rf $INSTALL/storage
  enable_service unbound.service
}
