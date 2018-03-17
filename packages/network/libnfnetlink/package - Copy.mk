PKG_NAME="libnfnetlink"
PKG_VERSION="20171108"
PKG_URL="ftp://ftp.netfilter.org/pub/libnfnetlink/snapshot/libnfnetlink-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"