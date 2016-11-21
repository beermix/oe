PKG_NAME="nettle"
PKG_VERSION="3.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.lysator.liu.se/~nisse/nettle"
PKG_URL="ftp://ftp.gnu.org/gnu/nettle/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp openssl"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="nettle: a cryptographic library"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --enable-openssl \
			   --disable-documentation \
			   --enable-mini-gmp"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}