PKG_NAME="pango"
PKG_VERSION="1.40.14"
PKG_SHA256="90af1beaa7bf9e4c52db29ec251ec4fd0a8f2cc185d521ad1f88d01b3a6a17e3"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.pango.org/"
PKG_URL="http://ftp.gnome.org/pub/gnome/sources/pango/1.40/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib freetype fontconfig harfbuzz libXrender"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="pango: Library for layout and rendering of internationalized text"
PKG_LONGDESC="The goal of the Pango project is to provide an open-source framework for the layout and rendering of internationalized text. Pango is an offshoot of the GTK+ and GNOME projects, and the initial focus is operation in those environments, however there is nothing fundamentally GTK+ or GNOME specific about Pango. Pango uses Unicode for all of its encoding, and will eventually support output in all the worlds major languages."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-explicit-deps=no"

if [ "$DISPLAYSERVER" = "x11" ] ; then
  PKG_DEPENDS_TARGET+=" cairo libX11 libXft"
  PKG_CONFIGURE_OPTS_TARGET+=" --with-xft"
fi

if [ "$DISPLAYSERVER" = "weston" ] ; then
  PKG_DEPENDS_TARGET+=" wayland"
fi
