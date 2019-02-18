# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gtk3"
PKG_VERSION="3.24.5"
PKG_SHA256=""
PKG_LICENSE="LGPL"
PKG_SITE="https://ftp.acc.umu.se/pub/gnome/sources/gtk+/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/gtk+/${PKG_VERSION:0:4}/gtk+-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib:host at-spi2-atk atk cairo gdk-pixbuf glib libX11 libXi libXrandr libepoxy pango libXcursor"
PKG_TOOLCHAIN="configure"

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
#  export PKG_CONFIG_PATH="$(get_build_dir pango)/.$TARGET_NAME"
#  export CFLAGS="$CFLAGS -I$(get_build_dir pango) -L$(get_build_dir pango)/.$TARGET_NAME/pango"
}

#makeinstall_target() {
#  :
#}
