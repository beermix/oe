PKG_NAME="​iptraf-ng"
PKG_VERSION="master"
PKG_GIT_URL="git://repo.or.cz/iptraf-ng.git"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS"
}