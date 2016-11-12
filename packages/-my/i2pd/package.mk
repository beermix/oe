PKG_NAME="i2pd"
PKG_VERSION="8676a1b"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost libz openssl miniupnpc"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
   #export LIBS="-pthread"
}



make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS"
}

post_makeinstall_target() {
 rm -rf $INSTALL/usr/src/
 rm  $INSTALL/usr/LICENSE
}