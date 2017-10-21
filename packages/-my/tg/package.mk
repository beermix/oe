PKG_NAME="tg"
PKG_VERSION="x3"
PKG_URL="https://dl.dropboxusercontent.com/s/8b44s8uhpti6xt4/tg-x3.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  autoreconf --verbose --install --force -I m4
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
