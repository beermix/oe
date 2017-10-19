PKG_NAME="gtk+"
PKG_VERSION="3.22.24"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/gtk+/3.22/?C=M;O=D"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXi glib pango cairo gdk-pixbuf at-spi2-atk glib:host"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_LONGDESC="This is GTK+. GTK+, which stands for the Gimp ToolKit, is a library for creating graphical user interfaces for the X Window System. It is designed to be small, efficient, and flexible. GTK+ is written in C with a very object-oriented approach."

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_GLIB_GENMARSHAL=$SYSROOT_PREFIX/usr/bin/glib-genmarshal \
                           --disable-glibtest \
                           --enable-modules \
                           --enable-explicit-deps=no \
                           --disable-debug \
                           --disable-cups \
                           --disable-papi \
                           --enable-xkb \
                           --disable-xinerama \
                           --enable-gtk-doc-html"

post_makeinstall_target() {
  cp $PKG_DIR/files/settings.ini $INSTALL/etc/gtk-3.0/
}
