PKG_NAME="tg"
PKG_VERSION="x3"
PKG_URL="https://dl.dropboxusercontent.com/s/8b44s8uhpti6xt4/tg-x3.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
 cd $ROOT/$PKG_BUILD
 rm -rf .$TARGET_NAME
 
 strip_lto
 strip_gold
 
 MAKEFLAGS=-j1
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --enable-openssl=$SYSROOT_PREFIX/usr \
			      --enable-json \
			      --enable-static \
			      --enable-libevent=$SYSROOT_PREFIX/usr \
			      --enable-libconfig=$SYSROOT_PREFIX/usr \
			      --enable-libgcrypt=no \
			      --enable-extf \
			      --enable-python \
			      --disable-valgrind \
			      --enable-liblua \
			      --disable-option-checking"
		
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $ROOT/$PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/generate $INSTALL/usr/bin/
}
