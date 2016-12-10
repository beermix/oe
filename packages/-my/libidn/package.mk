KG_NAME="libidn"
PKG_VERSION="1.33"
PKG_URL="http://ftpmirror.gnu.org/libidn/libidn-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-local-libopts \
			      --disable-doc \
			      --disable-crywrap"