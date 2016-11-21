PKG_NAME="jemalloc"
PKG_VERSION="4.3.1"
PKG_ARCH="any"
PKG_GIT_URL="https://github.com/jemalloc/jemalloc"
PKG_DEPENDS_TARGET="toolchain"
PKG_IS_ADDON="no"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  sh autogen.sh
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --disable-valgrind --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL
  rm $SYSROOT_PREFIX/usr/lib/libjemalloc.so
  rm $SYSROOT_PREFIX/usr/lib/libjemalloc.so.2
}