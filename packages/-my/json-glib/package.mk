PKG_NAME="json-glib"
PKG_VERSION="1.4.2"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/json-glib/1.4/json-glib-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="my"
PKG_AUTORECONF="no"

PKG_MESON_OPTS_TARGET="--default_library=static"

