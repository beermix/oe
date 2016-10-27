PKG_NAME="neon"
PKG_VERSION="0.30.2"
PKG_URL="http://www.webdav.org/neon/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse libxml2 expat"
PKG_DEPENDS_HOST="toolchain fuse libxml2"
PKG_PRIORITY="optional"
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
			   --with-ssl=openssl \
			   --with-ca-bundle=/etc/ssl/cert.pem"


PKG_CONFIGURE_OPTS_HOST="--disable-shared \
			 --enable-static \
			 --disable-debug \
			 --disable-example \
			 --without-gssapi \
			 --disable-rpath
			 --disable-documentation \
			 --with-libxml2 \
			 --with-ssl=openssl \
			 --with-ca-bundle=/etc/ssl/cert.pem"
			 
#post_makeinstall_target() {
#  sed -i $INSTALL/usr/bin/neon-config -e "s|^prefix=/usr*|prefix=$ROOT/$TOOLCHAIN|g"
#  mv $INSTALL/usr/bin/neon-config $ROOT/$TOOLCHAIN/bin/neon-config
#  cp $ROOT/$PKG_BUILD/.x86_64-libreelec-linux-gnu/src/.libs/libneon.a $ROOT/$TOOLCHAIN/lib/libneon.a
#  cp $ROOT/$PKG_BUILD/.x86_64-libreelec-linux-gnu/src/.libs/libneon.la $ROOT/$TOOLCHAIN/lib/libneon.la
#}