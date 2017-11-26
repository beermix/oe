PKG_NAME="libedit"
PKG_VERSION="20170329-3.1"
PKG_URL="http://thrysoee.dk/editline/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"

