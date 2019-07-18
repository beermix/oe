# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libpciaccess"
PKG_VERSION="0.16"
PKG_SHA256="214c9d0d884fdd7375ec8da8dcb91a8d3169f263294c9a90c575bf1938"
PKG_LICENSE="OSS"
PKG_SITE="http://freedesktop.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros zlib"
PKG_LONGDESC="X.org libpciaccess library."

PKG_CONFIGURE_OPTS_TARGET="ac_cv_header_asm_mtrr_h=set \
                           --with-pciids-path=/usr/share \
                           --with-zlib "

pre_configure_target() {
  CFLAGS="$CFLAGS -D_LARGEFILE64_SOURCE"
}
