PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.11"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_11/libtorrent-rasterbar-1.0.11.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $ROOT/$PKG_BUILD/configure
  #strip_lto
  #strip_gold
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-python-binding \
			      --without-libiconv \
			      --disable-geoip \
			      --disable-silent-rules \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"