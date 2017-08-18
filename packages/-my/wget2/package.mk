PKG_NAME="wget2"
PKG_VERSION="e6d949a"
PKG_GIT_URL="https://github.com/rockdaboot/wget2"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="tools"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
                           --with-gnu-ld \
                           --disable-shared \
                           --enable-static \
                           --disable-ipv6 \
                           --with-ssl=openssl \
                           --with-openssl=yes"