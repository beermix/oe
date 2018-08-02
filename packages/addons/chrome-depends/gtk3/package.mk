# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
PKG_VERSION="3.23.2"
#PKG_SHA256="3f4461044402e9466a2d587e34d00a1cb92a59397b9458b4bce8ea0a4acf8179"
#PKG_VERSION="3.22.30" #at-spi2-atk
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="gtk+-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="The Gimp ToolKit (GTK) is a library for creating graphical user interfaces for the X Window System."
#PKG_TOOLCHAIN="autotools"

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
