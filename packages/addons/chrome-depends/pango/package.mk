# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pango"
PKG_VERSION="1.44.7"
PKG_SHA256="66a5b6cc13db73efed67b8e933584509f8ddb7b10a8a40c3850ca4a985ea1b1f"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnome.org/pub/gnome/sources/pango/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/pango/${PKG_VERSION:0:4}/pango-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain cairo freetype fontconfig fribidi glib harfbuzz libX11 libXft"
PKG_LONGDESC="The Pango library for layout and rendering of internationalized text."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET="-Dgtk_doc=false \
                       -Dinstall-tests=false \
                       -Dintrospection=false \
                       -Duse_fontconfig=true"

