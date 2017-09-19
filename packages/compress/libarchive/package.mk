PKG_NAME="libarchive"
PKG_VERSION="3.3.2"
PKG_URL="http://www.libarchive.org/downloads/libarchive-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gmp acl openssl expat pcre zlib lz4 xz bzip2 nettle libxml2"
PKG_DEPENDS_HOST="openssl:host zlib:host lzo:host xz:host bzip2:host lz4:host"
PKG_SECTION="compress"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-shared --enable-static --disable-rpath --disable-xattr --disable-acl --with-gnu-ld --with-pic"
			   
PKG_CONFIGURE_OPTS_TARGET="--disable-shared --disable-bsdtar --disable-bsdcat --disable-bsdcpio --with-pic"


