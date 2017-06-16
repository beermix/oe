PKG_NAME="librsvg"
PKG_VERSION="2.40.16"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.remotesensing.org/libtiff/"
PKG_URL="https://download.gnome.org/sources/librsvg/2.40/librsvg-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib gdk-pixbuf libxml2 pango cairo"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
