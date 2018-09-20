PKG_NAME="tg"
PKG_VERSION="04"
PKG_URL="https://dl.dropboxusercontent.com/s/hymg2hojsmx9kda/tg-04.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
 # slang fails to build in subdirs
 cd $PKG_BUILD
 rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --enable-libevent=$SYSROOT_PREFIX/usr \
			      --enable-libconfig=$SYSROOT_PREFIX/usr \
			      --disable-option-checking"
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/generate $INSTALL/usr/bin/
}
