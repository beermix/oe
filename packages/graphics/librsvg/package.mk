################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-present Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="librsvg"
PKG_VERSION="2.43.4"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://live.gnome.org/LibRsvg"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.43/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libcroco gdk-pixbuf pango"
PKG_PRIORITY="optional"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="librsvg is a free software SVG rendering library written as part of the GNOME project, intended to be lightweight and portable."
PKG_LONGDESC="librsvg is a free software SVG rendering library written as part of the GNOME project, intended to be lightweight and portable."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-introspection=no --disable-gtk-doc"

pre_configure_target() {
  export GDK_PIXBUF_QUERYLOADERS=$SYSROOT_PREFIX/usr/bin
}
