PKG_NAME="bluelog"
PKG_VERSION="1.1.2"
PKG_URL="ftp://ftp.digifail.com/software/bluelog/bluelog-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libevent openssl"

PKG_SECTION="security"


CPPFLAGS="$CPPFLAGS -I $(kernel_path)/usr/include"