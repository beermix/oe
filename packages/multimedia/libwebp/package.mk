PKG_NAME="libwebp"
PKG_VERSION="1.0.1"
PKG_URL="https://github.com/webmproject/libwebp/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

# Dependencies
get_graphicdrivers

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-swap-16bit-csp \
			      --enable-experimental \
			      --enable-libwebpmux \
			      --enable-libwebpmux \
			      --enable-libwebdemux \
			      --enable-libwebdecoder \
			      --enable-libwebextras"

#post_makeinstall_target() {
#  rm -rf $INSTALL
#}
