PKG_NAME="gtk3+"
PKG_VERSION="3.22.15"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.gtk.org/"
PKG_URL="https://dl.dropboxusercontent.com/s/cysplfjcg9oxjls/gtk3+-3.22.15.tar.xz"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXi glib pango cairo gdk-pixbuf at-spi2-atk"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_LONGDESC="This is GTK+. GTK+, which stands for the Gimp ToolKit, is a library for creating graphical user interfaces for the X Window System. It is designed to be small, efficient, and flexible. GTK+ is written in C with a very object-oriented approach."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_GLIB_GENMARSHAL=$SYSROOT_PREFIX/usr/bin/glib-genmarshal \
                           --disable-glibtest \
                           --enable-modules \
                           --enable-explicit-deps=no \
                           --enable-debug=no \
                           --disable-cups \
                           --disable-papi \
                           --enable-xkb \
                           --disable-gtk-doc-html \
                           --enable-silent-rules \
                           --disable-gtk-doc \
                           --disable-gtk-doc-pdf \
                           --disable-man \
                           --disable-gtk-doc"

post_makeinstall_target() {
  cp $PKG_DIR/files/settings.ini $INSTALL/etc/gtk-3.0/
}
