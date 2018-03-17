PKG_NAME="libnetfilter_queue"
PKG_VERSION="20171108"
PKG_URL="http://ftp.netfilter.org/pub/libnetfilter_queue/snapshot/libnetfilter_queue-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
