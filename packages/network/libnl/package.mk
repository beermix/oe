# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv) --disable-debug

PKG_NAME="libnl"
#PKG_VERSION="65b3dd5"
PKG_VERSION="3.4.0"
PKG_SHA256="b7287637ae71c6db6f89e1422c995f0407ff2fe50cecd61a312b6a9b0921f5bf"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/thom311/libnl/releases"
PKG_URL="https://github.com/thom311/libnl/releases/download/libnl${PKG_VERSION//./_}/libnl-$PKG_VERSION.tar.gz"
#PKG_URL="https://github.com/thom311/libnl/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library for applications dealing with netlink socket."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
    export CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
}

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-cli \
                           --disable-debug"
