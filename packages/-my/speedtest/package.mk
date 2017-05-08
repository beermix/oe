PKG_NAME="speedtest"
PKG_VERSION="v1.11"
PKG_GIT_URL="https://github.com/taganaka/SpeedTest"
PKG_DEPENDS_TARGET="toolchain curl libxml2 openssl"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo"
  #export LDFLAGS="-static"
}