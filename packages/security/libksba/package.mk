PKG_NAME="libksba"
PKG_VERSION="1.3.5"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/libksba/libksba-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"