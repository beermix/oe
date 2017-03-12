PKG_NAME="diffutils"
PKG_VERSION="3.5"
PKG_SITE="http://www.gnu.org/software/diffutils/"
PKG_URL="ftp://ftp.gnu.org/gnu/diffutils/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_SHORTDESC="GNU Diffutils"
PKG_LONGDESC="GNU Diffutils is a package of several programs related to finding differences between files."
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"