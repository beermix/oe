PKG_NAME="bmon"
PKG_VERSION="fdd139a"
PKG_GIT_URL="https://github.com/tgraf/bmon"
PKG_DEPENDS_TARGET="toolchain ncurses confuse"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export LIBS="-lncursesw -ltinfo -pthread"
  export CFLAGS="$CFLAGS -D_GNU_SOURCE"
}