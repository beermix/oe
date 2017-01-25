PKG_NAME="c-ares"
PKG_VERSION="cares-1_12_0"
PKG_GIT_URL="https://github.com/c-ares/c-ares"
PKG_DEPENDS_TARGET="toolchain zlib openssl libgpg-error"
PKG_DEPENDS_HOST="toolchain zlib openssl libgpg-error"

PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
			      --disable-shared \
			      --enable-static \
			      --with-gnu-ld"