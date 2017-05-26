PKG_NAME="ps3remote"
PKG_VERSION="7d20fa3e"
PKG_GIT_URL="https://github.com/rootlis/ps3remote"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $ROOT/$PKG_BUILD/ps3remote $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}