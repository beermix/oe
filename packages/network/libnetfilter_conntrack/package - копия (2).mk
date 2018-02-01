PKG_NAME="libnetfilter_conntrack"
PKG_VERSION="2017-07-25-e8704326"
PKG_URL="http://192.168.1.200:8080/%2Flibnetfilter_conntrack-2017-07-25-e8704326.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnfnetlink libnl"
PKG_SOURCE_DIR="libnetfilter_conntrack*"
PKG_SECTION="network"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-pic"