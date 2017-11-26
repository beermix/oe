PKG_NAME="aufs-util"
PKG_VERSION="287daf5"
PKG_GIT_URL="git://git.code.sf.net/p/aufs/aufs-util"
PKG_GIT_BRANCH="aufs4.x-rcN"
#PKG_SOURCE_DIR="aufs2-util"
PKG_SECTION="devel"



pre_configure_target() {
# attr fails to build in subdirs
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  strip_lto
  strip_gold
}

make_target() {
  make HOSTCC="$HOSTCC" CC="$CC" CFLAGS="$CFLAGS" AR="$AR" LD="$LD" CPPFLAGS="$CPPFLAGS -I$(get_pkg_build linux)/include/uapi/" -j1
}