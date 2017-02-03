PKG_NAME="zizzania"
PKG_VERSION="8f2062f"
PKG_GIT_URL="https://github.com/cyrus-and/zizzania"
PKG_DEPENDS_TARGET="toolchain libcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  cp -r $PKG_BUILD/src/* $PKG_BUILD/
}

pre_configure_target() {
   export MAKEFLAGS="-j1"
   cd $ROOT/$PKG_BUILD
   strip_lto
   #strip_gold
}

make_target() {
  scons CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $ROOT/$PKG_BUILD/zizzania $INSTALL/usr/sbin/
}


makeinstall_target() {
  :
}