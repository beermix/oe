PKG_NAME="npth"
PKG_VERSION="1.5"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/npth/npth-1.5.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"