PKG_NAME="jemalloc"
PKG_VERSION="5.2.1"
PKG_SHA256="34330e5ce276099e2e8950d9335db5a875689a4c6a56751ef3b1d8c537f887f6"
PKG_URL="https://github.com/jemalloc/jemalloc/releases/download/$PKG_VERSION/jemalloc-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2 libxslt libgpg-error libgcrypt"

PKG_CONFIGURE_OPTS_TARGET="--enable-autogen"

make_target() {
  make build_lib_static
}

#makeinstall_target() {
#  cp lib/libjemalloc.a $SYSROOT_PREFIX/usr/lib
#  cp lib/libjemalloc_pic.a $SYSROOT_PREFIX/usr/lib
#}

#post_makeinstall_target() {
#  rm -rf $SYSROOT_PREFIX/usr/lib/libjemalloc.so*
#  rm -rf $SYSROOT_PREFIX/usr/lib/libjemalloc.so
#}
