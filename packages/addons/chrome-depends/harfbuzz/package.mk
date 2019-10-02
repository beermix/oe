# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="harfbuzz"
PKG_VERSION="2.6.2"
PKG_SHA256="34b907453ac19e2e15fea71764a1e9b390a20049bb6a884198c832a2dec26b2e"
PKG_LICENSE="GPL"
PKG_SITE="https://www.freedesktop.org/software/harfbuzz/release/?C=M;O=D"
PKG_URL="https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-$PKG_VERSION.tar.bz2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain cairo freetype glib icu"
PKG_LONGDESC="HarfBuzz is an OpenType text shaping engine."
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--with-icu \
			      --with-freetype \
			      --with-glib \
			      --disable-gtk-doc \
			      --disable-gtk-doc-html \
			      --disable-gtk-doc-pdf"

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -pthread -ldl"
}
