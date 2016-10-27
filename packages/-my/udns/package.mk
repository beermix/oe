PKG_NAME="udns"
PKG_VERSION="3afeb27"
PKG_GIT_URL="https://github.com/lparam/udns"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD
  #mkdir -p $INSTALL/usr/lib
  #mkdir -p $INSTALL/usr/include
  mkdir -p $INSTALL/usr/bin
 ./configure --disable-ipv6
}  

MAKEFLAGS="-j1"

make_target() {
make CC="$CC" AR="$AR" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS"
}

post_make_target() {
  #$STRIP $ROOT/$PKG_BUILD/libudns.a
  cp $ROOT/$PKG_BUILD/libudns.a $SYSROOT_PREFIX/usr/lib
  cp $ROOT/$PKG_BUILD/udns.h $SYSROOT_PREFIX/usr/include
  cp -fv $ROOT/$PKG_BUILD/dnsget $INSTALL/usr/bin/
  cp -fv $ROOT/$PKG_BUILD/rblcheck $INSTALL/usr/bin/
  cp -fv $ROOT/$PKG_BUILD/ex-rdns $INSTALL/usr/bin/
  #cp -fv $ROOT/$PKG_BUILD/libudns.a $INSTALL/usr/lib/
  #cp -fv $ROOT/$PKG_BUILD/udns.h $INSTALL/usr/include/
}

makeinstall_target() {
  :
}