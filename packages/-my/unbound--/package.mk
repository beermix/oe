PKG_NAME="unbound"
PKG_VERSION="master"
PKG_URL="https://github.com/jedisct1/unbound/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl libevent expat"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="-C \
		--with-pthreads \
		--sysconfdir=/storage/.config \
		--prefix=/usr \
		--enable-cachedb \
		--enable-static \
		--with-libevent=$SYSROOT_PREFIX/usr"
		
post_makeinstall_target() {
  rm -rf $INSTALL/storage
}
