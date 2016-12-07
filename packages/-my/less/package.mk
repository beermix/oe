PKG_NAME="less"
PKG_VERSION="487"
PKG_URL="http://www.greenwoodsoftware.com/less/less-$PKG_VERSION.tar.gz"
PKG_BUILD_DEPENDS_TARGET="toolchain netbsd-curses libedir"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  unset CPPFLAGS
  export LIBS="-ltermcap -lcurses -lterminfo"
  export CFLAGS="-Wall -g -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
}
