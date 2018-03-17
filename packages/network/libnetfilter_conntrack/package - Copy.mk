PKG_NAME="libnetfilter_conntrack"
PKG_VERSION="20171023"
PKG_URL="ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-$PKG_VERSION.tar.bz2"
PKG_URL="ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/snapshot/libnetfilter_conntrack-20171023.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 
PKG_SECTION="my"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

