PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="d2f6104"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  strip_lto
  strip_gold
  sh autotool.sh
  export CFLAGS="$CFLAGS -Ofast -pipe"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --with-gnu-ld \
			      --disable-python-binding \
			      --without-libiconv \
			      --disable-geoip \
			      --enable-silent-rules \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"