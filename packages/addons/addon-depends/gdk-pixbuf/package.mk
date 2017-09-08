################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="gdk-pixbuf"
PKG_VERSION="2.36.4"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/?C=M;O=D"
PKG_URL="http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/2.36/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib libjpeg-turbo libpng jasper tiff"
PKG_SECTION="x11/toolkits"
PKG_SHORTDESC="gdk-pixbuf: a GNOME library for image loading and manipulation."
PKG_LONGDESC="gdk-pixbuf (GdkPixbuf) is a GNOME library for image loading and manipulation. The GdkPixbuf documentation contains both the programmer's guide and the API reference."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

post_unpack() {
  sed 's/ tests//' $ROOT/$PKG_BUILD/Makefile.in
}

PKG_CONFIGURE_OPTS_TARGET="gio_can_sniff=yes \
                           --disable-glibtest \
                           --with-x11 \
                           --with-libpng=$SYSROOT_PREFIX/usr \
                           --with-libjpeg=$SYSROOT_PREFIX/usr \
                           --with-libtiff=no \
                           --with-libjasper=$SYSROOT_PREFIX/usr"

post_makeinstall_target() {
  cp $PKG_DIR/config/gdk-pixbuf.loaders $INSTALL/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
}
