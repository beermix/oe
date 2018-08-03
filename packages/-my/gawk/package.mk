PKG_NAME="gawk"
PKG_VERSION="4.1.4"
PKG_URL="http://ftpmirror.gnu.org/gawk/gawk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="gmp:host mpfr:host"
PKG_DEPENDS_TARGET="gmp:host mpfr:host readline"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--without-libsigsegv"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"