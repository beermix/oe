PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.1.1"
PKG_URL="https://github.com/arvidn/libtorrent/releases/download/libtorrent-1_1_1/libtorrent-rasterbar-1.1.1.tar.gz"
PKG_SOURCE_DIR="libtorrent_libtorrent-1_1_1"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain boost Python:host Python:target zlib bzip2 curl"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
  
}

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-static \
			   --enable-encryption \
			   --enable-python-binding \
			   --disable-deprecated-functions \
			   --with-boost=$SYSROOT_PREFIX/usr \
			   --with-boost-libdir=$SYSROOT_PREFIX/usr/lib"
              
post_makeinstall_target() {
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.a
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.la
  rm -f $INSTALL/usr/lib/pkgconfig/libtorrent-rasterbar.pc
  rm -fr $INSTALL/usr/include/libtorrent
}

