PKG_NAME="ps3remote"
PKG_VERSION="7d20fa3e"
PKG_GIT_URL="https://github.com/rootlis/ps3remote"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
  strip_gold
}

make_target() {
  make CC="$CC" CFLAGS="-Wall -DDEBUG=0 -O2" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  $STRIP $ROOT/$PKG_BUILD/ps3remote
  cp $ROOT/$PKG_BUILD/ps3remote $INSTALL/usr/bin/
}

makeinstall_target() {
  :
}

post_install () {
  enable_service ps3remote.service
}