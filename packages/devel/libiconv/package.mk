PKG_NAME="libiconv"
PKG_VERSION="1.16"
PKG_SHA256="e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04"
PKG_SITE="https://savannah.gnu.org/projects/libiconv/"
PKG_URL="http://ftp.gnu.org/pub/gnu/libiconv/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="Libiconv converts from one character encoding to another through Unicode conversion."
PKG_LONGDESC="Libiconv converts from one character encoding to another through Unicode conversion."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--host=$TARGET_NAME \
			      --build=$HOST_NAME \
			      --enable-shared \
			      --enable-static \
			      --disable-rpath \
			      --enable-relocatable \
			      --enable-extra-encodings"
