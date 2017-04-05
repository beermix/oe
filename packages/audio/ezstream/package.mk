PKG_NAME="ezstream"
PKG_VERSION="8e0d5d6"
PKG_GIT_URL="https://github.com/xiph/ezstream"
PKG_DEPENDS_TARGET="toolchain libshout libxml2 taglib libvorbis"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"