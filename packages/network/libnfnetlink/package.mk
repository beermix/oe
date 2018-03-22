PKG_NAME="libnfnetlink"
PKG_VERSION="1.0.1"
PKG_URL="ftp://ftp.netfilter.org/pub/libnfnetlink/libnfnetlink-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_SECTION="network"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

