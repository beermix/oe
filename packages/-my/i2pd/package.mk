PKG_NAME="i2pd"
PKG_VERSION="2.12.0"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
   strip_lto
   #export LIBS="-pthread"
}


make_target() {
  make \
       CC="$CC" \
       LD="$LD -Wall" \
       AR="$AR" \
       XCFLAGS="$CFLAGS" \
       XLDFLAGS="$LDFLAGS" \
       all
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL_DEV/usr/bin/
  cp $ROOT/$PKG_BUILD/i2pd $INSTALL/usr/bin/
}