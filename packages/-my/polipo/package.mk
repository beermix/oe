PKG_NAME="polipo"
PKG_VERSION="ab52932"
PKG_GIT_URL="https://github.com/jech/polipo"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="service/proxy"
PKG_SHORTDESC="Polipo - a caching web proxy"
PKG_LONGDESC="Polipo - a caching web proxy"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_MAKE_OPTS_TARGET="CC=$TARGET_CC AR=$TARGET_AR BUILD_CC=$HOST_CC -j1"

CFLAGS="-march=corei7-avx -mtune=corei7-avx -fdata-sections -ffunction-sections -O3 -Wa,--noexecstack"
LDFLAGS="-s -Wl,-O1,--as-needed"

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" -j1
}

install_target(){
:
}

post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/polipo $INSTALL/usr/bin/
}
