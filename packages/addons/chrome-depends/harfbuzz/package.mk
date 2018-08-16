# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="harfbuzz"
PKG_VERSION="1.8.8"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freedesktop.org/wiki/Software/HarfBuzz"
PKG_URL="https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain cairo freetype glib icu"
PKG_LONGDESC="HarfBuzz is an OpenType text shaping engine."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-coretext=no \
			      --with-uniscribe=no \
			      --with-graphite2=no \
			      --with-cairo=yes \
			      --with-icu=yes \
			      --with-freetype=yes \
			      --with-glib=yes \
			      --disable-gtk-doc \
                           --disable-gtk-doc-html \
                           --disable-gtk-doc-pdf"

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -pthread -ldl"
}
