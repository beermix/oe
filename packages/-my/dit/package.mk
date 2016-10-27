PKG_NAME="dit"
PKG_VERSION="4524b88"
PKG_URL="https://github.com/hishamhm/dit/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libevent openssl"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-cxx m4_pattern_allow=yes --prefix=/usr"
