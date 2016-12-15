PKG_NAME="zapret"
PKG_VERSION="2c30f8e"
PKG_GIT_URL="https://github.com/bol-van/zapret"
PKG_DEPENDS_TARGET="toolchain linux systemd libnfnetlink libnetfilter_queue libnetfilter_conntrack ipset"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
cd nfq
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS"
cd ..
cd tpws
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS"
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $ROOT/$PKG_BUILD/nfq/nfqws $INSTALL/usr/sbin/
  cp $ROOT/$PKG_BUILD/tpws/tpws $INSTALL/usr/sbin/
}

makeinstall_target() {
  :
}