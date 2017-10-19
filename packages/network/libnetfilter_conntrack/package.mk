PKG_NAME="libnetfilter_conntrack"
PKG_VERSION="1.0.6"
PKG_URL="ftp://ftp.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl" 
PKG_SECTION="my"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}