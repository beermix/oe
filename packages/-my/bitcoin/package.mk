PKG_NAME="bitcoin"
PKG_VERSION="0.13.2"
PKG_SITE="https://bitcoin.org/"
PKG_URL="https://bitcoin.org/bin/bitcoin-core-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain db miniupnpc libdaemon boost libevent"
PKG_SECTION="web"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --enable-static \
			      --with-miniupnpc \
			      --disable-ccache \
			      --disable-hardening \
			      --disable-tests \
			      --enable-upnp-default \
			      --disable-shared \
			      --with-gnu-ld \
			      --with-daemon"

