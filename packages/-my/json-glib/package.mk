PKG_NAME="json-glib"
PKG_VERSION="1.2.8"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/json-glib/1.2/json-glib-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="my"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic"
