PKG_NAME="gawk"
PKG_VERSION="4.1.4"
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline ncurses"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--bindir=/bin --without-selinux --disable-debug --disable-nls --enable-threads=posix"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"