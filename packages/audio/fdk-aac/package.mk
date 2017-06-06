PKG_NAME="fdk-aac"
PKG_VERSION="v0.1.5"
PKG_GIT_URL="https://github.com/mstorsjo/fdk-aac"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"
