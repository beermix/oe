PKG_NAME="jemalloc"
PKG_VERSION="4.3.1"
PKG_URL="https://github.com/jemalloc/jemalloc/releases/download/$PKG_VERSION/jemalloc-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --disable-valgrind"

post_makeinstall_target() {
  rm -rf $INSTALL
  rm $SYSROOT_PREFIX/usr/lib/libjemalloc.so
  rm $SYSROOT_PREFIX/usr/lib/libjemalloc.so.2
}