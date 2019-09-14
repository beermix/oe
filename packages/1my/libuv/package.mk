PKG_NAME="libuv"
PKG_VERSION="v1.32.0"
PKG_SITE="https://dist.libuv.org/dist/"
PKG_URL="http://dist.libuv.org/dist/$PKG_VERSION/libuv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"

post_unpack() {
  echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" > $PKG_BUILD/m4/libuv-extra-automake-flags.m4
}
