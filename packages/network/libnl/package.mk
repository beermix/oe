# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libnl"
PKG_VERSION="65b3dd5"
PKG_SHA256="9a77c99c61c1c1cdc823075c9dd94db24a78e8019676083ba249c4fa4d3cfb67"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/thom311/libnl/releases"
PKG_URL="https://github.com/thom311/libnl/releases/download/libnl${PKG_VERSION//./_}/libnl-$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/thom311/libnl/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library for applications dealing with netlink socket."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-cli \
                           --disable-debug"
