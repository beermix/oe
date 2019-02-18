PKG_NAME="zapret"
PKG_VERSION="4668258"
PKG_URL="https://github.com/bol-van/zapret/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux systemd libnfnetlink libnetfilter_queue libnetfilter_conntrack ipset"
PKG_SECTION="my"


make_target() {
  cd nfq
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" -j1
  cd ..
  cd tpws
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" -j1
}

post_make_target() {
  mkdir -p $INSTALL/usr/sbin/
  mkdir -p $INSTALL_DEV/usr/sbin/
  cp $PKG_BUILD/nfq/nfqws $INSTALL/usr/sbin/
  cp $PKG_BUILD/tpws/tpws $INSTALL/usr/sbin/
}

makeinstall_target() {
  :
}