PKG_NAME="inetutils"
PKG_VERSION="1.9.4"
PKG_URL="http://ftpmirror.gnu.org/inetutils/inetutils-1.9.4.tar.xz"
PKG_DEPENDS_TARGET="toolchain netbsd-curses"
PKG_SECTION="python/system"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

LIBS="$LIBS -lcurses -lterminfo"

PKG_CONFIGURE_OPTS_TARGET="--disable-ipv6 --disable-shared"