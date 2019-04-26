PKG_NAME="tg"
PKG_VERSION="master"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain readline libevent jansson zlib libconfig openssl lua"
PKG_SECTION="debug/tools"


unpack() {
  git clone --recursive -v --depth 1 git://github.com/vysheng/tg $PKG_BUILD
  git reset --hard $PKG_VERSION
  rm -rf .git
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      --with-zlib=$SYSROOT_PREFIX/usr \
			      --enable-openssl=$SYSROOT_PREFIX/usr \
			      --enable-json \
			      --enable-static \
			      --enable-libevent \
			      --enable-libconfig \
			      --disable-option-checking \
			      --enable-libgcrypt=no \
			      --enable-extf \
			      --enable-python \
			      --disable-valgrind \
			      --enable-liblua"
		
		
post_make_target() {
  mkdir -p $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/telegram-cli $INSTALL/usr/bin/tg
  cp $PKG_BUILD/bin/tl-parser $INSTALL/usr/bin/
  cp $PKG_BUILD/bin/generate $INSTALL/usr/bin/
}
