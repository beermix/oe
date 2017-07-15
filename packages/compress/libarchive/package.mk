PKG_NAME="libarchive"
PKG_VERSION="3.3.2"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl expat pcre zlib lz4 xz bzip2"
PKG_DEPENDS_HOST="libressl:host zlib:host lzo:host xz:host bzip2:host lz4:host"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--disable-shared \
			    --with-pic \
			    --disable-rpath \
			    --disable-bsdtar \
			    --disable-bsdcat \
			    --disable-bsdcpio"
			   
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
