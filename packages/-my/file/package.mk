PKG_NAME="file"
PKG_VERSION="5.32"
PKG_SITE="http://www.darwinsys.com/file/"
PKG_URL="ftp://ftp.astron.com/pub/file/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib attr expat file:host"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_HOST="--enable-fsect-man5 --enable-static --disable-shared --with-pic --with-gnu-ld"
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"