KG_NAME="libidn2"
PKG_VERSION="0.16"
PKG_URL="ftp://alpha.gnu.org/gnu/libidn/libidn2-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --disable-nls \
			      --with-gnu-ld \
			      --with-sysroot=$SYSROOT_PREFIX"