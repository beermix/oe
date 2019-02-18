PKG_NAME="ps3remote"
PKG_VERSION="7d20fa3ea87cfa90b191fa9b5106aed65387128c"
PKG_GIT_URL="https://github.com/rootlis/ps3remote"
PKG_URL="https://github.com/rootlis/ps3remote/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain systemd"
PKG_SECTION="my"



make_target() {
  make CC="$CC" AR="$AR" CFLAGS="-O2 -pipe -fstack-protector-strong -DDEBUG=0" CPPFLAGS="$CPPFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $PKG_BUILD/ps3remote $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}