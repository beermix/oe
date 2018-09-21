# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="opus"
PKG_VERSION="1.3-rc2"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.opus-codec.org"
PKG_URL="https://archive.mozilla.org/pub/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="audio"
PKG_SHORTDESC="Codec designed for interactive speech and audio transmission over the Internet"
PKG_LONGDESC="Codec designed for interactive speech and audio transmission over the Internet"

if [ "$TARGET_ARCH" = "arm" ]; then
  PKG_FIXED_POINT="--enable-fixed-point"
else
  PKG_FIXED_POINT="--disable-fixed-point"
fi

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           $PKG_FIXED_POINT"
