PKG_NAME="speedtest"
PKG_VERSION="54a2998"
PKG_GIT_URL="https://github.com/taganaka/SpeedTest"
PKG_DEPENDS_TARGET="toolchain curl libxml2 openssl"
PKG_AUTORECONF="no"

CONCURRENCY_MAKE_LEVEL=1

pre_configure_target() {
  export LIBS="-lterminfo"
}