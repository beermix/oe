PKG_NAME="less"
PKG_VERSION="551"
PKG_SHA256="ff165275859381a63f19135a8f1f6c5a194d53ec3187f94121ecd8ef0795fe3d"
PKG_URL="http://www.greenwoodsoftware.com/less/less-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain readline pcre"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-regex=pcre"