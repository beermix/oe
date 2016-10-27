PKG_NAME="lrzip"
PKG_VERSION="2c15f12"
PKG_GIT_URL="https://github.com/ckolivas/lrzip"
PKG_DEPENDS_TARGET="toolchain lzo libpthread-stubs zlib bzip2"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-gnu-ld"