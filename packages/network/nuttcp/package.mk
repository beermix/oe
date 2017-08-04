PKG_NAME="nuttcp"
PKG_VERSION="8.1.4"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"

make_target() {
  $CC -v $CFLAGS $CPPFLAGS $LDFLAGS $PKG_DIR/nuttcp-8.1.4.c -o nuttcp
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  $STRIP $ROOT/$PKG_BUILD/nuttcp
  cp $ROOT/$PKG_BUILD/nuttcp $INSTALL/usr/bin/nuttcp
}

makeinstall_target() {
  :
}

post_install () {
  enable_service nuttcp.service
}