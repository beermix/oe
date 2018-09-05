# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
#PKG_VERSION="3.22.30"
#PKG_SHA256="a1a4a5c12703d4e1ccda28333b87ff462741dc365131fbc94c218ae81d9a6567"
PKG_VERSION="3.24.0"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_SOURCE_DIR="gtk+-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain glib:host at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="The Gimp ToolKit (GTK) is a library for creating graphical user interfaces for the X Window System."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-x \
                           --x-includes=$SYSROOT/usr/include/X11 \
                           --x-libraries=$SYSROOT/usr/lib \
                           --with-gdktarget=x11 \
                           --enable-modules \
                           --enable-explicit-deps=no \
                           --disable-debug \
                           --enable-shm \
                           --disable-cups \
                           --disable-schemas-compile \
                           --enable-x11-backend \
                           --enable-xkb \
                           --disable-gtk-doc-html \
                           --with-xinput \
                           --enable-silent-rules"

#pre_configure_target() {
#  LIBS="$LIBS -lXcursor"
#}

#make_target() {
#  make SRC_SUBDIRS="gdk gtk modules"
#  $MAKEINSTALL SRC_SUBDIRS="gdk gtk modules"
#}

#makeinstall_target() {
#  make install DESTDIR=$INSTALL SRC_SUBDIRS="gdk gtk modules"
#}