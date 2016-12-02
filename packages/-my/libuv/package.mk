PKG_NAME="libuv"
PKG_VERSION="v1.10.1"
PKG_GIT_URL="https://github.com/libuv/libuv"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  sh autogen.sh
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"