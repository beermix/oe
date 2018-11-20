PKG_NAME="gtk+"
PKG_VERSION="2.24.32"
PKG_SHA256="b6c8a93ddda5eabe3bfee1eb39636c9a03d2a56c7b62828b359bf197943c582e"
#PKG_VERSION="aca9558"
PKG_URL="https://github.com/GNOME/gtk/archive/${PKG_VERSION}.tar.gz"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/GNOME/gtk/tree/gtk-2-24"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/GNOME/gtk/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXdamage libXcursor libXi glib pango cairo gdk-pixbuf shared-mime-info"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_GLIB_GENMARSHAL=$TOOLCHAIN/bin/glib-genmarshal \
                           --disable-glibtest \
                           --enable-modules \
                           --enable-explicit-deps=no \
                           --disable-debug \
                           --enable-shm \
                           --disable-cups \
                           --disable-papi \
                           --enable-xkb \
                           --disable-xinerama \
                           --disable-gtk-doc-html \
                           --with-xinput=yes \
                           --enable-silent-rules"
make_target() {
  $MAKEINSTALL SRC_SUBDIRS="gdk gtk modules"
}

makeinstall_target() {
  $MAKEINSTALL SRC_SUBDIRS="gdk gtk modules"
  make install DESTDIR=$INSTALL SRC_SUBDIRS="gdk gtk modules"
}

post_makeinstall_target() {
  echo gtk-font-name=\"Liberation Sans 12\" > $INSTALL/etc/gtk-2.0/gtkrc
}
