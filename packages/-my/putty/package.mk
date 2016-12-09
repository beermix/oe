PKG_NAME="putty"
PKG_VERSION="0.67"
PKG_URL="https://the.earth.li/~sgtatham/putty/latest/putty-$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="libevent-c51b159cff9f5e86696f5b9a4c6f517276056258"
PKG_DEPENDS_TARGET="toolchain zlib openssl"

PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			  --enable-static \
			  --disable-debug-mode"