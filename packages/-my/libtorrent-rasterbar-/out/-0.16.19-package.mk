PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="0.16.19"
PKG_SITE="http://www.boost.org/"
PKG_URL="http://downloads.sourceforge.net/project/libtorrent/libtorrent/${PKG_NAME}-${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain boost Python"

PKG_SECTION="devel"
PKG_SHORTDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability."
PKG_LONGDESC="libtorrent is a feature complete C++ bittorrent implementation focusing on efficiency and scalability. It runs on embedded devices as well as desktops. It boasts a well documented library interface that is easy to use. It comes with a simple bittorrent client demonstrating the use of the library."





configure_target() {
  cd $PKG_BUILD

  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"

autoreconf -i; ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --enable-silent-rules \
              --disable-encryption \
              --enable-static \
              --with-boost-thread=$SYSROOT_PREFIX/usr/lib \
              --with-boost-regex=$SYSROOT_PREFIX/usr/lib \
              --with-boost-filesystem=$SYSROOT_PREFIX/usr/lib \
              --with-boost-locale=$SYSROOT_PREFIX/usr/lib \
              --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
              --with-boost-python=$SYSROOT_PREFIX/usr/lib \
              --prefix=/usr \
              --enable-python-binding
}

post_makeinstall_target() {
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.a
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.la
  rm -f $INSTALL/usr/lib/pkgconfig/libtorrent-rasterbar.pc
  rm -fr $INSTALL/usr/include/libtorrent
}