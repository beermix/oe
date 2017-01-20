PKG_NAME="nettle"
PKG_VERSION="3.2"
PKG_SITE="http://www.lysator.liu.se/~nisse/nettle"
PKG_URL="http://www.lysator.liu.se/~nisse/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="security"
PKG_SHORTDESC="nettle: a cryptographic library"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared \
			   --disable-openssl \
			   --enable-mini-gmp \
			   CC_FOR_BUILD=$HOST_CC"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
