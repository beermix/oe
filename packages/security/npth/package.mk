PKG_NAME="npth"
PKG_VERSION="1.5"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/npth/npth-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"
PKG_SECTION="my"



pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"