PKG_NAME="file"
PKG_VERSION="5.30"
PKG_SITE="http://www.darwinsys.com/file/"
PKG_URL="ftp://ftp.astron.com/pub/file/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib attr expat file:host"
PKG_SECTION="tools"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="--disable-shared"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"