PKG_NAME="libassuan"
PKG_VERSION="2.4.3"
PKG_URL="ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libgpg-error"

#pre_configure_target() {
#  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
#  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
#}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-gnu-ld --with-pic"