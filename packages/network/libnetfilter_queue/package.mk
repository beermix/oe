PKG_NAME="libnetfilter_queue"
PKG_VERSION="1.0.3"
PKG_URL="http://ftp.netfilter.org/pub/libnetfilter_queue/libnetfilter_queue-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SECTION="network"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-pic"