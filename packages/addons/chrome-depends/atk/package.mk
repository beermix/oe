# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="atk"
PKG_VERSION="2.29.2"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/atk/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/atk/${PKG_VERSION:0:4}/atk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib glib:host"
PKG_LONGDESC="ATK provides the set of accessibility interfaces that are implemented by other toolkits and applications."
PKG_BUILD_FLAGS="+pic"

PKG_MESON_OPTS_TARGET="-Ddocs=false \
                       -Dintrospection=false"
