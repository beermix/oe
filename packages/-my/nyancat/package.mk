PKG_NAME="nyancat"
PKG_VERSION="c925313"
PKG_GIT_URL="https://github.com/klange/nyancat.git"
PKG_DEPENDS_TARGET="toolchain readline ncurses"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


pre_configure_target() {
  export LIBS="-lterminfo"
  export MAKEFLAGS=-j1
}