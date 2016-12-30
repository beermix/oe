PKG_NAME="libevent"
PKG_VERSION="2.0.22-stable"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/libevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --with-gnu-ld \
			      --disable-samples \
			      --disable-debug-mode \
			      --enable-openssl"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
