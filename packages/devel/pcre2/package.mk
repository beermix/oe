PKG_NAME="pcre2"
PKG_VERSION="10.32"
PKG_SHA256=""
PKG_SITE="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/?C=M;O=D"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST="zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_USE_CMAKE="no"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic:host +pic"

#PKG_CONFIGURE_OPTS_TARGET="--enable-pcre2-8 --enable-pcre2-16 --disable-pcre2grep-callout"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			      --enable-static \
			      --enable-utf8 \
			      --enable-pcre2-16 \
			      --enable-jit \
			      --enable-unicode-properties \
			      --with-gnu-ld"

PKG_CONFIGURE_OPTS_HOST="--prefix=$TOOLCHAIN $PKG_CONFIGURE_OPTS_TARGET"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
