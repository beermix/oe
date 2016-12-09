PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="0.16.19"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.boost.org/"
PKG_URL="http://192.168.1.4/libtorrent-rasterbar-0.16.19.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain boost Python zlib bzip2"

PKG_SECTION="devel"
PKG_SHORTDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability."
PKG_LONGDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops. It boasts a well documented library interface that is easy to use. It comes with a simple bittorrent client demonstrating the use of the library."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"



configure_target() {
  cd $ROOT/$PKG_BUILD

  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"

  ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --disable-encryption \
              --enable-static \
              --with-boost-locale=$SYSROOT_PREFIX/usr/lib \
              --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
              --with-boost-python=$SYSROOT_PREFIX/usr/lib \
              --with-boost-thread=$SYSROOT_PREFIX/usr/lib \
              --prefix=/usr \
              --enable-python-binding
}

post_makeinstall_target() {
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.a
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.la
  rm -f $INSTALL/usr/lib/pkgconfig/libtorrent-rasterbar.pc
  rm -fr $INSTALL/usr/include/libtorrent
}
