PKG_NAME="jsonrpc-glib"
PKG_VERSION="3.25.2"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/jsonrpc-glib/3.25/jsonrpc-glib-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain openssl"
PKG_SECTION="my"



PKG_MESON_OPTS_TARGET="-Dintrospection=false -Ddocs=false"