PKG_NAME="tg"
PKG_VERSION="002"
PKG_URL="https://dl.dropboxusercontent.com/s/2ipj1e9srji0ekm/tg-002.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  export LIBS="-lreadline"
  #export LUA_LIBS="-L$SYSROOT_PREFIX/usr/lib -llua -lm"
  #export LDFLAGS="$LDFLAGS -llua -lm" 
  #strip_lto
  #autoreconf --verbose --install --force -I m4
}


PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-zlib=$ROOT/$TOOLCHAIN \
			      --enable-openssl \
			      --enable-json \
			      --enable-static \
			      --enable-libevent \
			      --enable-libconfig \
			      --enable-extf \
			      --disable-python \
			      --disable-valgrind \
			      --enable-liblua"
		
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $ROOT/$PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/generate $INSTALL/usr/bin/
}
