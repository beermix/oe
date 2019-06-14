PKG_NAME="librsvg"
PKG_VERSION="2.31.0"
PKG_SITE="http://live.gnome.org/LibRsvg"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.31/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libcroco gdk-pixbuf pango"
PKG_LONGDESC="librsvg is a free software SVG rendering library written as part of the GNOME project, intended to be lightweight and portable."

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"