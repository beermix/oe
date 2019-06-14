PKG_NAME="libuv"
PKG_VERSION="v1.28.0"
PKG_SITE="https://dist.libuv.org/dist/"
PKG_URL="http://dist.libuv.org/dist/$PKG_VERSION/libuv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic:host +pic"

post_unpack() {
  echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" > $PKG_BUILD/m4/libuv-extra-automake-flags.m4
}

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
