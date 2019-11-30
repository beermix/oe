# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
PKG_VERSION="3.24.13"
PKG_SHA256="4c775c38cf1e3c534ef0ca52ca6c7a890fe169981af66141c713e054e68930a9"
#PKG_VERSION="e3860d2"
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/GNOME/gtk/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango"
PKG_LONGDESC="A library for creating graphical user interfaces for the X Window System."
PKG_TOOLCHAIN="meson"
PKG_TOOLCHAIN="configure"

PKG_MESON_OPTS_TARGET="-Dx11_backend=true \
                       -Dwayland_backend=false \
                       -Dbroadway_backend=false \
                       -Dwin32_backend=false \
                       -Dquartz_backend=false \
                       -Dmir_backend=false \
                       -Dcolord=no \
                       -Dgtk_doc=false \
                       -Dman=false \
                       -Dintrospection=false \
                       -Dxinerama=no \
                       -Ddemos=false \
                       -Dexamples=false \
                       -Dtests=false \
                       -Dinstalled_tests=false"

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
  CFLAGS="$CFLAGS -DG_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS"
  export GLIB_COMPILE_RESOURCES=glib-compile-resources GLIB_MKENUMS=glib-mkenums GLIB_GENMARSHAL=glib-genmarshal
}