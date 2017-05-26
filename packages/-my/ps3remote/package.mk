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
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  cp $ROOT/$PKG_BUILD/ps3remote $INSTALL/usr/bin/
}


makeinstall_target() {
  :
}

post_install () {
  enable_service ps3remote.service
}