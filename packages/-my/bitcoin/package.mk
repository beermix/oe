PKG_NAME="bitcoin"
PKG_VERSION="0.17.0"
PKG_SHA256="98ef39e851644bba1ac51edaa53c7c47c20a3980333def7bc642c8261a12785e"
PKG_SITE="https://bitcoin.org/bin/"
PKG_URL="https://bitcoin.org/bin/bitcoin-core-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="${PKG_NAME}-0.15.0"
PKG_DEPENDS_TARGET="toolchain db miniupnpc libdaemon boost libevent"
PKG_SECTION="web"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --with-miniupnpc \
			      --disable-tests \
			      --enable-upnp-default \
			      --disable-shared \
			      --with-daemon"