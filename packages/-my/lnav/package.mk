PKG_NAME="lnav"
PKG_VERSION="c606e11"
PKG_GIT_URL="https://github.com/tstack/lnav"
PKG_DEPENDS_HOST="toolchain sqlite"
PKG_SECTION="tools"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

CC_FOR_BUILD="$HOST_CC"
CFLAGS_FOR_BUILD="$HOST_CFLAGS"

pre_configure_target() {
  # gdb could fail on runtime if build with LTO support
    strip_lto
    cd $ROOT/$PKG_BUILD
    sh autogen.sh
}