PKG_NAME="nghttp2"
PKG_VERSION="1.14.1"
PKG_URL="https://github.com/nghttp2/nghttp2/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error boost CUnit spdylay jansson boost Python:target"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --disable-app \
			   --disable-hpack-tools \
			   --disable-silent-rules \
			   --with-gnu-ld \
			   --with-boost=yes"
			   
post_makeinstall_target() {
  rm -rf $INSTALL
}