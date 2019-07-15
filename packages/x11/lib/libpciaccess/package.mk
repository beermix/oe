# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libpciaccess"
PKG_VERSION="0.15"
PKG_SHA256="a75643bb5cd02f6da8667d437b76492842dd56bc88e3dfb8410f5d535b99f5dc"
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
