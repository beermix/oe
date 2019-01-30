# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="at-spi2-core"
PKG_VERSION="2.31.1"
PKG_SHA256=""
PKG_LICENSE="LGPL-2.1"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/at-spi2-core/?C=M;O=D"
PKG_URL="https://download.gnome.org/sources/$PKG_NAME/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain atk dbus glib libXtst"

PKG_MESON_OPTS_TARGET="-Denable_docs=false \
                       -Denable-introspection=no"

#pre_configure_target() {
#  LDFLAGS="$LDFLAGS -lXext"
#}
