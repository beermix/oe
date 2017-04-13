PKG_NAME="tg"
PKG_VERSION="master"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"
PKG_AUTORECONF="yes"

unpack() {
  git clone --recursive -v --depth 1 git://github.com/vysheng/tg $PKG_BUILD
  cd $PKG_BUILD
  git reset --hard $PKG_VERSION
  rm -rf .git
  cd $ROOT
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --enable-openssl=$SYSROOT_PREFIX/usr \
			      --enable-json \
			      --enable-static \
			      --enable-libevent \
			      --enable-libconfig \
			      --enable-libgcrypt=no \
			      --enable-extf \
			      --enable-python \
			      --disable-valgrind \
			      --enable-liblua"
		
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $ROOT/$PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $ROOT/$PKG_BUILD/bin/generate $INSTALL/usr/bin/
}
