PKG_NAME="libpsl"
PKG_VERSION="libpsl-0.17.0"
PKG_GIT_URL="https://github.com/rockdaboot/libpsl"
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"

PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --disable-gtk-doc"
