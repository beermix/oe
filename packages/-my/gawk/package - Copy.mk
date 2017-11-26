PKG_NAME="gawk"
PKG_VERSION="4.2.0"
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline ncurses"
PKG_SECTION="my"


PKG_CONFIGURE_OPTS_TARGET="--without-selinux --disable-debug --without-libsigsegv"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"