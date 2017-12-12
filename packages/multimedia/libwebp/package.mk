PKG_NAME="libwebp"
PKG_VERSION="0.4.4"
PKG_URL="https://johnvansickle.com/ffmpeg/release-source/libwebp-0.4.4.tar.xz"
PKG_DEPENDS_TARGET="toolchain intel-vaapi-driver libva"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"

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
