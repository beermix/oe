PKG_NAME="json-c"
PKG_VERSION="0.13.1"
PKG_SHA256="94a26340c0785fcff4f46ff38609cf84ebcd670df0c8efd75d039cc951d80132"
PKG_SITE="https://github.com/json-c/json-c/wiki"
PKG_URL="https://github.com/json-c/json-c/archive/$PKG_VERSION.tar.gz"
PKG_URL="https://s3.amazonaws.com/json-c_releases/releases/json-c-$PKG_VERSION-nodoc.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"

pre_configure_host() {
  export CFLAGS="$CFLAGS -Wno-implicit-fallthrough"
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -Wno-implicit-fallthrough"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-threading"
