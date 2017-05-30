PKG_NAME="knot"
PKG_VERSION="2.4.3"
PKG_URL="https://secure.nic.cz/files/knot-dns/knot-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl jansson gnutls libidn2 liburcu protobuf"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-recvmmsg=no 
			      --enable-fastparser \
			      --enable-recvmmsg=yes \
			      --enable-dnstap \
			      --disable-silent-rules"