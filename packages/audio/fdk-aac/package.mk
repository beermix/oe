PKG_NAME="fdk-aac"
PKG_VERSION="0.1.6"
PKG_URL="https://github.com/mstorsjo/fdk-aac/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
