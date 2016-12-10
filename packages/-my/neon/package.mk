PKG_NAME="neon"
PKG_VERSION="0.30.2"
PKG_URL="http://www.webdav.org/neon/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse libxml2 expat"
PKG_SECTION="tools"
PKG_AUTORECONF="no"
  
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
  ln -sf neon-config $ROOT/$TOOLCHAIN/bin/neon-config
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/neon-config
  rm -rf $INSTALL
}