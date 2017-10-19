PKG_NAME="libwebp"
PKG_VERSION="50d1a84"
PKG_GIT_URL="https://chromium.googlesource.com/webm/libwebp"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"

PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

get_graphicdrivers

PKG_CONFIGURE_OPTS_TARGET="--enable-swap-16bit-csp \
			      --enable-experimental 
			      --enable-libwebp-mux \
			      --enable-libwebp-demux \
			      --enable-libwebp-decoder \
			      --enable-libwebp-extras \
			      --disable-static"

#post_makeinstall_target() {
#  rm -rf $INSTALL
#}
