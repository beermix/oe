# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="at-spi2-atk"
PKG_VERSION="2.32.0"
PKG_SHA256=""
PKG_LICENSE="LGPL-2.1"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/at-spi2-atk/?C=M;O=D"
PKG_URL="https://download.gnome.org/sources/$PKG_NAME/${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain at-spi2-core atk libX11 libxml2"
