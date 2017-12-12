PKG_NAME="fdk-aac"
PKG_VERSION="e2e35b8"
PKG_GIT_URL="https://github.com/mstorsjo/fdk-aac"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"
