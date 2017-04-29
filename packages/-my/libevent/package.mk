PKG_NAME="libevent"
PKG_VERSION="2.1.8-stable"
PKG_URL="https://github.com/libevent/libevent/releases/download/release-$PKG_VERSION/libevent-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-samples \
			      --enable-openssl \
			      --enable-function-sections \
			      --disable-clock-gettime \
			      --disable-debug-mode"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}
