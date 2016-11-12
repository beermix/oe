PKG_NAME="gawk"
PKG_VERSION="4.1.4"
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline netbsd-curses"
PKG_DEPENDS_HOST="make:host"
PKG_PRIORITY="optional"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-gnu-ld"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"