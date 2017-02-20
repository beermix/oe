PKG_NAME="libarchive"
PKG_VERSION="3.3.0"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain expat pcre zlib xz bzip2 lz4 openssl"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
			   
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"