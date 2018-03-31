PKG_NAME="fdk-aac"
PKG_VERSION="a30bfce"
PKG_URL="https://github.com/mstorsjo/fdk-aac/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"
