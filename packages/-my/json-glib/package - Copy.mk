PKG_NAME="json-glib"
PKG_VERSION="1.4.2"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/json-glib/1.4/json-glib-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_SECTION="my"




make_target() {
 cd build
  meson setup --prefix=/usr --buildtype=release --disable-shared
  ninja
}


PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic"

