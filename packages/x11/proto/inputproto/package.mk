# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="inputproto"
PKG_VERSION="2.3.2"
PKG_SHA256="893a6af55733262058a27b38eeb1edc733669f01d404e8581b167f03c03ef31d"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/proto/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_LONGDESC="inputproto: Input extension headers"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--without-xmlto"
