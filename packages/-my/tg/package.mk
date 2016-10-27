PKG_NAME="tg"
PKG_VERSION="03"
PKG_URL="https://dl.dropboxusercontent.com/s/4e2ghw5njzz60tz/tg-03.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl libedit"
PKG_PRIORITY="optional"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  export LIBS="-lreadline -ledit -lterminfo"
  #export LDFLAGS=-static
  #git submodule update --init --recursive
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
			   --enable-python \
			   --disable-liblua"
		
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $ROOT/$PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/generate $INSTALL/usr/bin/
}