# SPDX-License-Identifier: GPL-2.0-or-later-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pango"
PKG_VERSION="1.44.6"
PKG_SHA256="3e1e41ba838737e200611ff001e3b304c2ca4cdbba63d200a20db0b0ddc0f86c"
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

#pre_configure_target() {
#  export PKG_CONFIG_PATH="$(get_build_dir cairo)/.$TARGET_NAME/src":"$(get_build_dir libXft)/.$TARGET_NAME/src"
#}

#makeinstall_target() {
#  :
#}