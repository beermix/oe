PKG_NAME="bmon"
PKG_VERSION="b44d015"
PKG_URL="https://github.com/tgraf/bmon/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses confuse"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="-lncursesw -ltinfo -lm -lpthread"
}