PKG_NAME="diffutils"
PKG_VERSION="3.6"
PKG_SITE="http://www.gnu.org/software/diffutils/"
PKG_URL="ftp://ftp.gnu.org/gnu/diffutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="GNU Diffutils"
#PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-nls \
			      --without-libsigsegv-prefix \
			      --without-libiconv-prefix \
			      --without-libintl-prefix"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"