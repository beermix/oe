PKG_NAME="fping"
PKG_VERSION="0f36ddd"
PKG_GIT_URL="https://github.com/schweikert/fping"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"