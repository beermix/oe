PKG_NAME="file"
PKG_VERSION="5.37"
PKG_SHA256="e9c13967f7dd339a3c241b7710ba093560b9a33013491318e88e6b8b57bae07f"
PKG_SITE="ftp://ftp.astron.com/pub/file/"
PKG_URL="ftp://ftp.astron.com/pub/file/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib file:host"
PKG_SECTION="tools"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-Os|"`
}

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"