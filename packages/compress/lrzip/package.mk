PKG_NAME="lrzip"
PKG_VERSION="1a30639"
PKG_URL="https://github.com/ckolivas/lrzip/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib lzo xz bzip2"
PKG_DEPENDS_HOST="zlib:host lzo:host xz:host bzip2:host"
PKG_SECTION="compress"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-largefile --disable-doc"
PKG_CONFIGURE_OPTS_HOST="--enable-largefile --disable-doc --with-zlib=$TOOLCHAIN"

