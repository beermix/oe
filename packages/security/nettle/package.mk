PKG_NAME="nettle"
PKG_VERSION="3.3"
PKG_SITE="http://www.lysator.liu.se/~nisse/nettle"
PKG_URL="https://ftp.gnu.org/gnu/nettle/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/depends"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-mini-gmp"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}