PKG_NAME="i2pd"
PKG_VERSION="034bff5"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc boost"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_USE_CMAKE="no"

pre_configure_target() {
   strip_lto
   strip_gold
   
   CC="$CC"
   CXX="$CXX"
   AR="$AR"
   CFLAGS="$CFLAGS"
   CPPFLAGS="$CPPFLAGS"
   LDFLAGS="$LDFLAGS"
}

