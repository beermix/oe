# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libass"
PKG_VERSION="0.14.0"
PKG_SHA256="881f2382af48aead75b7a0e02e65d88c5ebd369fe46bc77d9270a94aa8fd38a2"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/libass/libass"
PKG_URL="https://github.com/libass/libass/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain freetype fontconfig fribidi"
PKG_SECTION="multimedia"
PKG_SHORTDESC="libass: a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format."
PKG_LONGDESC="libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format. It is mostly compatible with VSFilter"

PKG_CONFIGURE_OPTS_TARGET="--disable-test \
                           --enable-fontconfig \
                           --disable-harfbuzz \
                           --with-gnu-ld"

if [ $TARGET_ARCH = "x86_64" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET yasm:host"
  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_TARGET --enable-asm"
fi
