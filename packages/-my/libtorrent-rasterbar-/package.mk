PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="c074e87"
PKG_SITE="https://github.com/arvidn/libtorrent/tree/RC_1_0"
PKG_GIT_URL="https://github.com/arvidn/libtorrent"
#PKG_GIT_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_11/libtorrent-rasterbar-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat boost libsigc++"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $PKG_BUILD
  sh autotool.sh
  
  #	strip_lto
  
  #export CFLAGS="$CFLAGS -fPIC"
  #export CXXFLAGS="$CXXFLAGS -fPIC"
  #export LDFLAGS="$LDFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --disable-deprecated-functions \
			      --disable-geoip \
			      --enable-silent-rules \
			      --disable-iconv \
			      --with-gnu-ld \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"

