PKG_NAME="jpeg"
PKG_VERSION="9b"
PKG_URL="http://www.ijg.org/files/jpegsrc.v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared --enable-static"
PKG_CONFIGURE_OPTS_HOST="--enable-shared --enable-static"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}