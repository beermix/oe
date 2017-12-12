PKG_NAME="SpeedTest"
PKG_VERSION="4ecabc8"
PKG_GIT_URL="https://github.com/taganaka/SpeedTest"
PKG_DEPENDS_TARGET="toolchain confuse"
PKG_TOOLCHAIN="autotools"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  export LIBS="-lterminfo"
}