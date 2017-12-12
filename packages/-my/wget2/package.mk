PKG_NAME="wget2"
PKG_VERSION="f73b251"
PKG_GIT_URL="https://github.com/rockdaboot/wget2"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --disable-ipv6 \
                           --with-ssl=openssl \
                           --with-openssl=yes"