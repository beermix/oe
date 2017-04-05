PKG_NAME="powertop"
PKG_VERSION="746abef"
PKG_GIT_URL="https://github.com/fenrus75/powertop"
PKG_DEPENDS_TARGET="toolchain readline libnl"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"