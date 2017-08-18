PKG_NAME="libuv"
PKG_VERSION="v1.14.0"
PKG_URL="http://dist.libuv.org/dist/$PKG_VERSION/libuv-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_HOST="ccache:host autotools:host autoconf:host"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" > $ROOT/$PKG_BUILD/m4/libuv-extra-automake-flags.m4
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"