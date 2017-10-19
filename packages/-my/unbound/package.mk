PKG_NAME="unbound"
PKG_VERSION="cf49b0a"
PKG_GIT_URL="https://github.com/jedisct1/unbound"
PKG_DEPENDS_TARGET="toolchain expat openssl libevent libsodium expat"
PKG_SECTION="my"

PKG_AUTORECONF="yes"

LTO_SUPPORT="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-dsa \
			      --disable-gost \
			      --disable-rpath \
			      --enable-pie \
			      --enable-flto \
			      --enable-relro-now \
			      --disable-shared \
			      --disable-cachedb \
			      --disable-dnscrypt \
			      --disable-dnstap \
			      --enable-checking \
			      --enable-allsymbols \
			      --enable-systemd \
			      --with-pthreads \
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
