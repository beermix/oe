PKG_NAME="jemalloc"
PKG_VERSION="5.0.1"
PKG_URL="https://github.com/jemalloc/jemalloc/releases/download/$PKG_VERSION/jemalloc-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"



PKG_CONFIGURE_OPTS_TARGET="--disable-autogen --disable-valgrind"

make_target() {
  make build_lib_static
}