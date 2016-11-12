PKG_NAME="libedit"
PKG_VERSION="20160903-3.1"
PKG_SITE="http://www.gnu.org/readline"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

pre_configure_target() {
  export CFLAGS="-D__STDC_ISO_10646__ $CFLAGS"
  export MAKEFLAGS=-j1
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --with-gnu-ld \
			   --enable-widec"

post_make_target() {
  ln -sf libedit.a $SYSROOT_PREFIX/usr/lib/libreadline.a
  ln -sf libedit.so $SYSROOT_PREFIX/usr/libreadline.so
  mkdir -p $SYSROOT_PREFIX/usr/include/readline
  touch $SYSROOT_PREFIX/usr/include/readline/history.h
  touch $SYSROOT_PREFIX/usr/include/readline/tilde.h
  ln -sf ../editline/readline.h $SYSROOT_PREFIX/usr/include/readline/readline.h
}