PKG_NAME="ttyd"
PKG_VERSION="0a9ff2f"
PKG_GIT_URL="https://github.com/tsl0922/ttyd"
PKG_DEPENDS_TARGET="toolchain curl libxml2 openssl"
PKG_AUTORECONF="no"

pre_configure_target() {
  export LIBS="-lterminfo"
}