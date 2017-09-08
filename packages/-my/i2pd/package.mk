PKG_NAME="i2pd"
PKG_VERSION="2.15.0"
PKG_GIT_URL="https://github.com/PurpleI2P/i2pd"
PKG_DEPENDS_TARGET="toolchain boost zlib openssl miniupnpc boost"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

strip_lto
strip_gold

make_target() {
  make CC="$CC" CXX="$CXX" AR="$AR" CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"
}