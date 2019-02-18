PKG_NAME="fping"
PKG_VERSION="4.0"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 
PKG_SECTION="my"



PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-ipv6"