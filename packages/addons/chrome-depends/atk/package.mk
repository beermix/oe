# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="atk"
PKG_VERSION="2.31.90"
PKG_SHA256="566c302b5b59f0b4cfff96b937e26e38b37d2148182d5ae5dc0a882d65a08ead"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/atk/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/atk/${PKG_VERSION:0:4}/atk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib glib:host"

PKG_MESON_OPTS_TARGET="-Ddocs=false \
                       -Dintrospection=false"
