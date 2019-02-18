KG_NAME="hashcat"
PKG_VERSION="c1d88f3"
PKG_GIT_URL="https://github.com/hashcat/hashcat"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"



pre_configure_target() {
   strip_lto
}

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $PKG_BUILD/ps3remote $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}