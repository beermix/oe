PKG_NAME="pcre2"
PKG_VERSION="10.22"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.pcre.org/"
PKG_URL="http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain readline"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--prefix=$ROOT/$TOOLCHAIN \
			 --enable-utf8 \
			 --enable-unicode-properties \
			 --with-gnu-ld \
			 --enable-static \
			 --disable-shared \
			 --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
			   --enable-static \
			   --enable-utf8 \
			   --enable-unicode-properties \
			   --with-gnu-ld"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LDFLAGS="$LDFLAGS -fPIC"
}

pre_configure_host() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LDFLAGS="$LDFLAGS -fPIC"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/$PKG_NAME-config
}
