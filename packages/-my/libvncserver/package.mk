PKG_NAME="libvncserver"
PKG_VERSION="3df54ce"
PKG_GIT_URL="https://github.com/LibVNC/libvncserver"
#PKG_SOURCE_DIR="libvncserver-LibVNCServer-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo libpng"
PKG_SECTION="libs"
PKG_PRIORITY="optional"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"
pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared \
			   --with-jpeg \
			   --with-png \
			   --without-ipv6 \
			   --without-sdl \
			   --without-gcrypt \
			   --with-zlib \
			   --with-gnu-ld \
                           --without-ssl \
                           --without-crypto \
                           --without-crypt \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-gnu-ld \
                           --without-client-gcrypt \
                           --without-gnutls \
                           --disable-option-checking"