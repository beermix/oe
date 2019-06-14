PKG_NAME="nuttcp"
PKG_VERSION="6.1.2"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

make_target() {
  $CC -O2 --param=ssp-buffer-size=4 -fstack-protector -Wall $PKG_DIR/nuttcp-$PKG_VERSION.c -o nuttcp
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  $STRIP $PKG_BUILD/nuttcp
  cp $PKG_BUILD/nuttcp $INSTALL/usr/bin/nuttcp
}

#post_install () {
#  enable_service nuttcp.service
#  enable_service nuttcp.socket
#}