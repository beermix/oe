PKG_NAME="i2pd"
PKG_VERSION="280407a"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#pre_configure_target() {
#   strip_lto
#}

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS"
}