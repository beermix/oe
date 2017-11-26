PKG_NAME="rfkill"
PKG_VERSION="0.5"
PKG_URL="https://dl.dropboxusercontent.com/s/dlkrm1b8iz48rwh/rfkill-0.5.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libs"



make_target() {
  make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" CFLAGS="$CFLAGS" -j1
}