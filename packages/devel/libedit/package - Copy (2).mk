PKG_NAME="libedit"
PKG_VERSION="20160903-3.1"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static --enable-widec"

#PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

#post_make_target() {
#  ln -sfi libedit.a $SYSROOT_PREFIX/usr/lib/libreadline.a
#  mkdir -p $SYSROOT_PREFIX/usr/include/readline
#  touch $SYSROOT_PREFIX/usr/include/readline/history.h
#  touch $SYSROOT_PREFIX/usr/include/readline/tilde.h
#  ln -sfi ../editline/readline.h $SYSROOT_PREFIX/usr/include/readline/readline.h
#}

configure_target() {
  : # nothing todo
}

make_target() {
  : # nothing todo
}

make_target_install() {
  : # nothing todo
}

post_make_target() {
  : # nothing todo
}

post_make_host() {
  ln -sfi libedit.a $ROOT/$TOOLCHAIN/lib/libreadline.a
  mkdir -p $ROOT/$TOOLCHAIN/include/readline
  touch $ROOT/$TOOLCHAIN/include/readline/history.h
  touch $ROOT/$TOOLCHAIN/include/readline/tilde.h
  ln -sfi ../editline/readline.h $ROOT/$TOOLCHAIN/include/readline/readline.h
}