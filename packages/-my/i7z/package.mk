PKG_NAME="i7z"
PKG_VERSION="5023138"
PKG_GIT_URL="https://github.com/ajaiantilal/i7z"
PKG_DEPENDS_TARGET="toolchain readline"

PKG_SECTION="tools"
PKG_AUTORECONF="no"

MAKEFLAGS="-j1"

make_target() {
LIBS="$LIBS -lcurses -lterminfo" make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS"
}