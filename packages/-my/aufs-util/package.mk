PKG_NAME="aufs-util"
PKG_VERSION="68be3d8"
PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
#PKG_SOURCE_DIR="aufs2-util"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" CFLAGS="$CFLAGS" AR="$AR" LD="$LD" CPPFLAGS="-I$(get_pkg_build linux)/usr/include/uapi -D_FORTIFY_SOURCE=2" -j1
}