PKG_NAME="pcre2"
PKG_VERSION="10.23"
PKG_SITE="http://www.pcre.org/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-utf8 \
			      --enable-pcre2-16 \
			      --enable-unicode-properties \
			      --with-gnu-ld \
			      --disable-stack-for-recursion \
			      --enable-pcre8 \
			      --disable-pcre2-32 \
			      --enable-jit \
			      --with-pic \
			      --enable-unicode-properties \
			      --enable-newline-is-anycrlf"
			      
PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
