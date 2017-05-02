PKG_NAME="libarchive"
PKG_VERSION="3.3.1"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat pcre libz xz bzip2"
PKG_DEPENDS_HOST="openssl:host zlib:host lzo:host xz:host bzip2:host"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-static \
			    --disable-shared \
			    --with-gnu-ld \
			    --with-pic \
			    --disable-rpath \
			    --disable-bsdtar \
			    --disable-bsdcat \
			    --disable-bsdcpio"
			   
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"