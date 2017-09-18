PKG_NAME="bitcoin"
PKG_VERSION="0.15.0"
PKG_SITE="https://bitcoin.org/bin/"
#PKG_URL="https://bitcoin.org/bin/bitcoin-core-0.15.0/test.rc3/bitcoin-0.15.0rc3.tar.gz"
PKG_URL="https://bitcoin.org/bin/bitcoin-core-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain db miniupnpc libdaemon boost libevent"
PKG_SECTION="web"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=3

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --enable-static \
			      --with-miniupnpc \
			      --disable-tests \
			      --enable-upnp-default \
			      --disable-shared \
			      --with-daemon"