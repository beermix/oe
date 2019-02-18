PKG_NAME="tgl"
PKG_VERSION="ffb04ca"
PKG_GIT_URL="https://github.com/vysheng/tgl"
PKG_KEEP_CHECKOUT="yes"
PKG_DEPENDS_TARGET="toolchain openssl"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			   ac_cv_func_realloc_0_nonnull=yes \
			   --with-zlib=$TOOLCHAIN \
			   --enable-json \
			   --enable-static \
			   --enable-libevent \
			   --enable-libconfig \
			   --enable-extf \
			   --enable-python \
			   --disable-liblua"
