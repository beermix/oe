# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
PKG_VERSION="3.22.20"
#sPKG_SHA256="65813efa5e0f681c522cc3fc8a966e142b2470caf31484b40d310466a2ca7ed3"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="gtk+-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="The Gimp ToolKit (GTK) is a library for creating graphical user interfaces for the X Window System."

PKG_CONFIGURE_OPTS_TARGET="--disable-cups \
                           --disable-debug \
                           --enable-explicit-deps=no \
                           --disable-gtk-doc \
                           --disable-gtk-doc-html \
                           --disable-man \
                           --enable-modules \
                           --enable-xkb \
                           --disable-schemas-compile \
                           --enable-x11-backend \
                           --disable-broadway-backend \
                           --disable-wayland-backend"

pre_configure_target() {
  LIBS="$LIBS -lXcursor"
}
