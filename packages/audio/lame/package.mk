# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="lame"
PKG_VERSION="3.100"
PKG_SHA256="835971db07e460ca431290396d7b702fe9a57a93fcfcd3f9e1086152422bf7d9"
PKG_LICENSE="LGPL"
PKG_SITE="http://lame.sourceforge.net/"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A high quality MPEG Audio Layer III (MP3) encoder."
PKG_BUILD_FLAGS="-parallel +pic"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-nasm \
                           --disable-rpath \
                           --disable-cpml \
                           --disable-gtktest \
                           --disable-efence \
                           --disable-analyzer-hooks \
                           --enable-decoder \
                           --disable-frontend \
                           --disable-mp3x \
                           --disable-mp3rtp \
                           --disable-dynamic-frontends \
                           --enable-expopt=no \
                           --enable-debug=no \
                           --with-gnu-ld \
                           --with-fileio=lame \
                           GTK_CONFIG=no"
