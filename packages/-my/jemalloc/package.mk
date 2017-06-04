PKG_NAME="jemalloc"
PKG_VERSION="4.5.0"
PKG_URL="https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-autogen --disable-valgrind"

make_target() {
  make build_lib_static
}