PKG_NAME="nghttp2"
PKG_VERSION="1.16.0"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libz openssl libgpg-error libevent"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --enable-lib-only \
			   --disable-app \
			   --disable-silent-rules \
			   --with-gnu-ld \
			   --enable-examples=no \
			   --disable-python-bindings \
			   --with-boost=no"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}