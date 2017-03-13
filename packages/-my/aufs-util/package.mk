PKG_NAME="aufs-util"
PKG_VERSION="-4.1_20161219"
PKG_URL="https://dl.dropboxusercontent.com/s/uz8ibw9ehegjdcu/aufs-util--4.1_20161219.tar.xz"
#PKG_VERSION="26333bc"
#PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
#PKG_GIT_BRANCH="aufs4.x-rcN"
#PKG_SOURCE_DIR="aufs2-util"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make HOSTCC="$HOSTCC" CC="$CC" CFLAGS="$CFLAGS" AR="$AR" LD="$LD" CPPFLAGS="$CPPFLAGS -I$(get_pkg_build linux)/include/uapi" -j1
}