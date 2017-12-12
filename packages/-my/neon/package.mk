PKG_NAME="neon"
PKG_VERSION="0.30.2"
PKG_URL="https://fossies.org/linux/www/neon-0.30.2.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse libxml2 expat openssl"
PKG_SECTION="tools"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
}
  
PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --disable-debug \
			      --disable-example \
			      --without-gssapi \
			      --disable-rpath \
			      --with-libxml2 \
			      --disable-documentation \
			      --with-ssl=openssl"

PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
			 
post_makeinstall_target() {
  ln -sf $PKG_NAME-config $TOOLCHAIN/bin/$PKG_NAME-config
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
  rm -rf $INSTALL
}