PKG_NAME="libnetfilter_queue"
PKG_VERSION="1.0.2"
PKG_URL="http://www.netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-1.0.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"