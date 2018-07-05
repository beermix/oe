################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#      Copyright (C) 2017 Escalade
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="gtk3"
PKG_VERSION="3.23.0"
PKG_SHA256="3f4461044402e9466a2d587e34d00a1cb92a59397b9458b4bce8ea0a4acf8179"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="gtk+-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="The Gimp ToolKit (GTK) is a library for creating graphical user interfaces for the X Window System."

PKG_CONFIGURE_OPTS_TARGET="--disable-cups \
                           --disable-debug \
                           --enable-explicit-deps=no \
                           --disable-glibtest \
                           --disable-gtk-doc \
                           --disable-gtk-doc-html \
                           --disable-man \
                           --enable-modules \
                           --disable-papi \
                           --disable-xinerama \
                           --enable-xkb"

pre_configure_target() {
  LIBS="$LIBS -lXcursor"
}
