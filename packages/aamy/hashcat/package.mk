KG_NAME="hashcat"
PKG_VERSION="master"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="debug/tools"


unpack() {
  git clone --recursive -v --depth 1 https://github.com/hashcat/hashcat $PKG_BUILD
}

make_target() {
  cd $PKG_BUILD/src
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