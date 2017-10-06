PKG_NAME="gobject-introspection"
PKG_VERSION="f9e8154"
PKG_GIT_URL="https://git.gnome.org/browse/gobject-introspection"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic --disable-doctool --disable-gtk-doc"
			      
post_makeinstall_target() {
  rm -rf $INSTALL
}