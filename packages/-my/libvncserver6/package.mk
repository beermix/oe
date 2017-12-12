PKG_NAME="libvncserver"
PKG_VERSION="master"
PKG_URL="https://github.com/LibVNC/libvncserver/archive/$PKG_VERSION.tar.gz"
#PKG_SOURCE_DIR="libvncserver-LibVNCServer-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo libpng"
PKG_SECTION="libs"


PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export LIBS="-ltermcap"
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --with-jpeg \
                           --with-png \
                           --without-ipv6 \
                           --without-sdl \
                           --without-gcrypt \
                           --with-zlib=$TOOLCHAIN \
                           --with-ssl \
                           --without-crypto \
                           --without-crypt \
                           --with-gnu-ld \
                           --without-client-gcrypt \
                           --without-gnutls"