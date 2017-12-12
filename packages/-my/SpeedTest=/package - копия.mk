PKG_NAME="speedtest"
PKG_VERSION="89f266b"
PKG_GIT_URL="https://github.com/mkschreder/speedtest"
PKG_DEPENDS_TARGET="toolchain confuse"
PKG_TOOLCHAIN="autotools"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  export LIBS="-lterminfo"
}