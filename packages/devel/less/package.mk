PKG_NAME="less"
PKG_VERSION="550"
PKG_SHA256="6a53639f08d7ed05b6e104b82c32193f79ac01a3eddb20e114e1c261948bd57b"
PKG_URL="http://www.greenwoodsoftware.com/less/less-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline pcre"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-regex=pcre"