PKG_NAME="nuttcp"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  $CC $CFLAGS -o nuttcp $PKG_DIR/nuttcp-8.1.3.c
}
