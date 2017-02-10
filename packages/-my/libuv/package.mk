PKG_NAME="libuv"
PKG_VERSION="v1.11.0"
PKG_GIT_URL="https://github.com/libuv/libuv"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" >$ROOT/$PKG_BUILD/m4/libuv-extra-automake-flags.m4
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"