PKG_NAME="libarchive"
PKG_VERSION="3.2.2"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat xz libz bzip2 openssl"
PKG_PRIORITY="optional"
PKG_SECTION="x11/lib"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"


PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			   --disable-shared \
			   --with-gnu-ld \
			   --without-xml2 \
			   --disable-bsdcpio \
			   --disable-bsdcat \
			   --disable-bsdtar"
			   
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"