PKG_NAME="faac"
PKG_VERSION="d4edf19"
PKG_URL="https://github.com/Distrotech/faac/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"