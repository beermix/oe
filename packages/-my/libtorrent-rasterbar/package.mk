PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.10"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_10/libtorrent-rasterbar-1.0.10.tar.gz"
#PKG_VERSION="d2f6104"
#PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_HOST="toolchain Python boost libiconv"
PKG_DEPENDS_TARGET="toolchain openssl expat boost libiconv"
PKG_SECTION="devel"
PKG_USE_CMAKE="yes"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  #cd $ROOT/$PKG_BUILD
  #sh autotool.sh
  #export CFLAGS="$CFLAGS -O3 -ffast-math"
  #export CXXFLAGS="$CXXFLAGS -std=gnu++98"
  #./autotool.sh
  #strip_lto
  sed -iv 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' $ROOT/$PKG_BUILD/configure
  sed -iv -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ $ROOT/$PKG_BUILD/ed25519/src/seed.cpp
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-python-binding \
			      --with-libiconv \
			      --disable-geoip \
			      --enable-silent-rules \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
			      
PKG_CMAKE_OPTS_TARGET="-Dshared=OFF -Dstatic_runtime=ON"