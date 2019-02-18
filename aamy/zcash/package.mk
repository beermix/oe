PKG_NAME="zcash"
PKG_VERSION="v1.0.11"
PKG_GIT_URL="https://github.com/zcash/zcash"
PKG_DEPENDS_TARGET="toolchain glib libevent boost libdaemon"
PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-wallet \
			      --disable-man \
			      --disable-debug \
			      --disable-mining \
			      --enable-hardening \
			      --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
			      --with-daemon \
			      --with-utils"
