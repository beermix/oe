PKG_NAME="libvncserver"
PKG_VERSION="c80879e"
PKG_GIT_URL="https://github.com/LibVNC/libvncserver"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo libpng"
PKG_SECTION="libs"

PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
			      --disable-shared \
			      --with-jpeg \
			      --with-png \
			      --without-ipv6 \
			      --without-sdl \
			      --without-gcrypt \
			      --with-zlib \
			      --with-pic \
			      --with-gnu-ld \
			      --without-ssl \
                           --without-crypto \
                           --without-crypt \
                           --without-client-gcrypt \
                           --without-gnutls"