PKG_NAME="gtk+"
PKG_VERSION="2.24.32"
PKG_SHA256="b6c8a93ddda5eabe3bfee1eb39636c9a03d2a56c7b62828b359bf197943c582e"
#PKG_VERSION="664537d"
PKG_URL="https://github.com/GNOME/gtk/archive/${PKG_VERSION}.tar.gz"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/GNOME/gtk/tree/gtk-2-24"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/GNOME/gtk/archive/${PKG_VERSION}.tar.gz"
#PKG_SOURCE_DIR="gtk-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXi glib pango cairo gdk-pixbuf"
PKG_DEPENDS_HOST="glib:host libpng:host tiff:host libjpeg-turbo:host gdk-pixbuf:host"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_LONGDESC="This is GTK+. GTK+, which stands for the Gimp ToolKit, is a library for creating graphical user interfaces for the X Window System. It is designed to be small, efficient, and flexible. GTK+ is written in C with a very object-oriented approach."
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
                           --with-xinput"
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
