PKG_NAME="aufs-util"
PKG_VERSION="e345b59"
PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
#PKG_SOURCE_DIR="aufs2-util"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

MAKEFLAGS=-j1

CPPFLAGS="-I$(get_pkg_build linux)/usr/include/uapi"

make_target() {
make CC="$CC" AR="$AR" LD="$LD" XCFLAGS="$CFLAGS" RANLIB="$RANLIB" XLDFLAGS="$LDFLAGS" MAKEDEPPROG="$CC" CFLAGS="$CFLAGS"
}