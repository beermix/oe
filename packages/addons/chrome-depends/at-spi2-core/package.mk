# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="at-spi2-core"
PKG_VERSION="2.33.2"
PKG_SHA256=""
PKG_LICENSE="OSS"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/at-spi2-core/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/at-spi2-core/${PKG_VERSION:0:4}/at-spi2-core-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain atk dbus glib libXtst"
PKG_LONGDESC="Protocol definitions and daemon for D-Bus at-spi."

PKG_MESON_OPTS_TARGET="-Denable_docs=false \
                       -Denable-introspection=no"

pre_configure_target() {
  TARGET_LDFLAGS="$LDFLAGS -lXext"
}
