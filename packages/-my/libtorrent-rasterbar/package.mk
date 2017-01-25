PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.10"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_0_10/libtorrent-rasterbar-1.0.10.tar.gz"
#PKG_VERSION="libtorrent-1_0_10"
#PKG_GIT_URL="https://github.com/arvidn/libtorrent"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain openssl expat boost"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  #./autotool.sh
  sed -i 's/$PKG_CONFIG openssl --libs-only-/$PKG_CONFIG openssl --static --libs-only-/' ./configure
  sed -i -e s/Windows.h/windows.h/ -e s/Wincrypt.h/wincrypt.h/ ./ed25519/src/seed.cpp
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --enable-python-binding \
			      --without-libiconv \
			      --disable-geoip \
			      --with-boost=$SYSROOT_PREFIX/usr \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"