PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="c074e87"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_0"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  sh autotool.sh

  strip_lto
}


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-deprecated-functions \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --disable-geoip \
			      --disable-silent-rules"
			      
			      