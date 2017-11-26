PKG_NAME="lsof"
PKG_VERSION="4.89"
PKG_URL="https://dl.dropboxusercontent.com/s/c3u89lk1pqk2gar/lsof-4.89.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"


pre_configure_target() {
  export LIBS="-lterminfo"
}
PKG_CONFIGURE_SCRIPT="Configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"