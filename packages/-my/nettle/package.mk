PKG_NAME="nettle"
PKG_VERSION="3.3"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.lysator.liu.se/~nisse/nettle"
PKG_URL="ftp://ftp.gnu.org/gnu/nettle/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp"
PKG_PRIORITY="optional"
PKG_SECTION="security"
PKG_SHORTDESC="nettle: a cryptographic library"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#pre_configure_target() {
# dont build parallel
 # MAKEFLAGS=-j1
  #export CFLAGS="$CFLAGS -fPIC"
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-openssl \
			   --disable-documentation \
			   --enable-static \
			   --enable-public-key \
			   --disable-shared \
			   --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}