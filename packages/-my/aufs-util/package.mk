PKG_NAME="aufs-util"
PKG_VERSION="68be3d8"
PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
#PKG_SOURCE_DIR="aufs2-util"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CPPFLAGS="-I$(get_pkg_build linux)/usr/include/uapi"

make_target() {
  make CC="$CC" CFLAGS="$CFLAGS -D_GNU_SOURCE -D_DEFAULT_SOURCE" AR="$AR" LD="$LD" -j1
}