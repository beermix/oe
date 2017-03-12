PKG_NAME="jpeg"
PKG_VERSION="9b"
PKG_URL="http://www.ijg.org/files/jpegsrc.v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="graphics"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}