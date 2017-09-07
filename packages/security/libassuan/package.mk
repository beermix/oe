PKG_NAME="libassuan"
PKG_VERSION="2.4.3"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"