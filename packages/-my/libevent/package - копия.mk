PKG_NAME="libevent"
PKG_VERSION="2.1.8-stable"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/libevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
   export LIBS="$LIBS -lz"
   export CFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-samples \
			      --enable-openssl"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
