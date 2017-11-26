PKG_NAME="libnetfilter_queue"
PKG_VERSION="1.0.2"
PKG_URL="http://ftp.netfilter.org/pub/libnetfilter_queue/libnetfilter_queue-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SECTION="my"
PKG_IS_ADDON="no"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-pic"