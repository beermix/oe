PKG_NAME="less"
PKG_VERSION="530"
PKG_URL="http://www.greenwoodsoftware.com/less/less-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline pcre"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-regex=pcre"