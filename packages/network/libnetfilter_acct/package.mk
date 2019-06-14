PKG_NAME="libnetfilter_acct"
PKG_VERSION="1.0.3"
PKG_URL="ftp://ftp.netfilter.org/pub/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 
PKG_SECTION="network"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

