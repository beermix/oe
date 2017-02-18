PKG_NAME="libnetfilter_queue"
PKG_VERSION="981025"
PKG_GIT_URL="http://git.netfilter.org/libnetfilter_queue"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"