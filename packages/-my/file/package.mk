PKG_NAME="file"
PKG_VERSION="5.28"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.darwinsys.com/file/"
PKG_URL="ftp://ftp.astron.com/pub/file/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain zlib attr expat file:host"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_HOST="--enable-static \
			 --disable-shared \
			 --with-gnu-ld"
			 
PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --with-gnu-ld"


