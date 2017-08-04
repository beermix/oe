PKG_NAME="nuttcp"
PKG_VERSION="8.1.4"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3 -Wall|"`
  CONCURRENCY_MAKE_LEVEL=1
  strip_lto
  strip_gold
}

make_target() {
  $CC $CFLAGS -o nuttcp $PKG_DIR/nuttcp-8.1.4.c
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  $STRIP $ROOT/$PKG_BUILD/nuttcp
  cp $ROOT/$PKG_BUILD/nuttcp $INSTALL/usr/bin/nuttcp
}


makeinstall_target() {
  :
}

post_install () {
  enable_service nuttcp.service
}