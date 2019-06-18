# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xextproto"
PKG_VERSION="7.3.0"
PKG_SHA256="f3f4b23ac8db9c3a9e0d8edb591713f3d70ef9c3b175970dd8823dfc92aa5bb0"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/proto/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_LONGDESC="Xext extension headers"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--without-xmlto"
