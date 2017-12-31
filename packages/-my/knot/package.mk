PKG_NAME="knot"
PKG_VERSION="2.4.3"
PKG_URL="https://secure.nic.cz/files/knot-dns/knot-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl jansson gnutls libidn2 liburcu protobuf-c"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-silent-rules"