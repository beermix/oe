PKG_NAME="bitcoin"
PKG_VERSION="0.13.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="https://bitcoin.org/"
PKG_URL="https://bitcoin.org/bin/bitcoin-core-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain db miniupnpc libdaemon boost libevent"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  #export MAKEFLAGS=-j1
  cd $ROOT/$PKG_BUILD
  #strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
			   --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			   --disable-silent-rules \
			   --enable-static \
			   --with-miniupnpc \
			   --disable-ccache \
			   --disable-hardening \
			   --disable-tests \
			   --enable-upnp-default \
			   --disable-shared \
			   --with-gnu-ld \
			   --with-daemon"

