PKG_NAME="gtk3"
PKG_VERSION="3.93.0"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.gtk.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/gtk+/3.93/gtk+-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="gtk+-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain atk libX11 libXrandr libXi glib:host pango cairo gdk-pixbuf at-spi2-atk"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gtk+: The Gimp ToolKit (GTK)"
PKG_LONGDESC="This is GTK+. GTK+, which stands for the Gimp ToolKit, is a library for creating graphical user interfaces for the X Window System. It is designed to be small, efficient, and flexible. GTK+ is written in C with a very object-oriented approach."
PKG_TOOLCHAIN="meson"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_GLIB_GENMARSHAL=$TOOLCHAIN/bin/glib-genmarshal \
                           --disable-glibtest \
                           --enable-modules \
                           --enable-explicit-deps=no \
                           --disable-debug \
                           --disable-cups \
                           --disable-papi \
                           --enable-xkb \
                           --disable-xinerama \
                           --disable-gtk-doc-html"
                           
PKG_MESON_OPTS_TARGET="-Denable-wayland-backend=false \
			  -Ddemos=false \
			  -Dbuild-tests=false \
			  -Dinstall-tests=false \
			  -Ddocumentation=false \
			  -Dman-pages=false \
			  -Denable-win32-backend=false \
			  -Denable-cloudprint-print-backend=no \
			  -Denable-cloudproviders=false \
			  -Ddisable-modules=true \
			  -Denable-quartz-backend=false \
			  -Denable-xinerama=no \
			  -Denable-x11-backend=false \
			  -Denable-mir-backend=false \
			  -Denable-colord=no \
			  -Dintrospection=false \
			  -Denable-papi-print-backend=no \
			  -Denable-vulkan=no \
			  -Denable-broadway-backend=false \
			  -Denable-cups-print-backend=no"

#post_makeinstall_target() {
#  cp $PKG_DIR/files/settings.ini $INSTALL/etc/gtk-3.0/
#}

pre_configure_target() {
  export LC_ALL=en_US.UTF-8
  
#  export CC="$HOST_CC"
#  export CXX="$HOST_CXX"
}
