PKG_NAME="libnetfilter_log"
PKG_VERSION="1.0.1"
PKG_URL="ftp://ftp.netfilter.org/pub/libnetfilter_log/libnetfilter_log-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"
