PKG_NAME="libnetfilter_acct"
PKG_VERSION="1.0.2"
PKG_URL="ftp://ftp.netfilter.org/pub/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"