PKG_NAME="i2pd"
PKG_VERSION="70f39eb"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost libz openssl miniupnpc"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
   strip_gold
  # export LDFLAGS="-ldl -lpthread"
}

post_makeinstall_target() {
 rm -rf $INSTALL/usr/src/
 rm  $INSTALL/usr/LICENSE
 $STRIP i2pd
}