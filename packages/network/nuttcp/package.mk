PKG_NAME="nuttcp"
PKG_VERSION="8.1.4"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_TOOLCHAIN="manual"

make_target() {
  $CC $CFLAGS $CPPFLAGS $LDFLAGS $PKG_DIR/nuttcp-8.1.4.c -o nuttcp
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  $STRIP $PKG_BUILD/nuttcp
  cp $PKG_BUILD/nuttcp $INSTALL/usr/bin/nuttcp
}

post_install () {
  enable_service nuttcp.service
}