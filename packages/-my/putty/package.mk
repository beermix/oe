PKG_NAME="putty"
PKG_VERSION="0.68"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --disable-debug-mode"