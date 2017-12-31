PKG_NAME="libusbmuxd"
PKG_VERSION="8e6ce39"
PKG_GIT_URL="https://github.com/libimobiledevice/libusbmuxd"
PKG_DEPENDS_TARGET="toolchain libplist"

PKG_SECTION="my"

PKG_TOOLCHAIN="autotools"


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --enable-static \
			   --disable-shared \
			   --with-gnu-ld \
			   --enable-silent-rules"
		
