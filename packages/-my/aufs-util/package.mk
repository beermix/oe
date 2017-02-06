PKG_NAME="aufs-util"
PKG_VERSION="5c7f789"
PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
#PKG_SOURCE_DIR="aufs2-util"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" CFLAGS="$CFLAGS -D_DEFAULT_SOURCE" AR="$AR" LD="$LD" CPPFLAGS="$CPPFLAGS -I$(get_pkg_build linux)/usr/include/uapi" -j1
}