PKG_NAME="​iptraf-ng"
PKG_VERSION="8b9c12a"
PKG_GIT_URL="git://repo.or.cz/iptraf-ng.git"
PKG_DEPENDS_TARGET="toolchain sqlite libpcap"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo -ltinfo"
}

make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" -j1
}
