# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXi"
PKG_VERSION="1.7.9"
PKG_SHA256="c2e6b8ff84f9448386c1b5510a5cf5a16d788f76db018194dacdc200180faf45"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXfixes"
PKG_SECTION="x11/lib"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  export CFLAGS="$CFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
  export CXXFLAGS="$CXXFLAGS -Os -fdata-sections -ffunction-sections -fno-semantic-interposition"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
                           --disable-docs \
                           --disable-specs \
                           --without-xmlto \
                           --without-fop \
                           --without-xsltproc \
                           --without-asciidoc \
                           --with-gnu-ld"
