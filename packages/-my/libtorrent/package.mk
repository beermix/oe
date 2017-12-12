PKG_NAME="libtorrent"
PKG_VERSION="c167c5a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rakshasa/libtorrent"
PKG_GIT_URL="https://github.com/rakshasa/libtorrent"
PKG_DEPENDS_TARGET="toolchain openssl zlib"
PKG_LONGDESC="libtorrent"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-debug \
			      --disable-shared \
			      --with-zlib=$SYSROOT_PREFIX/usr"
