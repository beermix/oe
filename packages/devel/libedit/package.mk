PKG_NAME="libedit"
PKG_VERSION="20170329-3.1"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export LIBS="$LIBS -lncursesw -ltinfo"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC"
  export LIBS="$LIBS -lncursesw -ltinfo"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"


