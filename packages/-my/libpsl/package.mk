PKG_NAME="libpsl"
PKG_VERSION="0486815"
PKG_URL="https://github.com/rockdaboot/libpsl/archive/$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="libevent-c51b159cff9f5e86696f5b9a4c6f517276056258"
PKG_BUILD_DEPENDS_TARGET="toolchain openssl libpsl:host"

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --disable-gtk-doc"
