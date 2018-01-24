PKG_NAME="jpeg"
PKG_VERSION="9b"
PKG_URL="http://www.ijg.org/files/jpegsrc.v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_TOOLCHAIN="autotools"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC"
}

PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static --with-gnu-ld"
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}