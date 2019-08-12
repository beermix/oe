# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017 Escalade
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="at-spi2-atk"
PKG_VERSION="2.33.1"
PKG_SHA256="faa38dcc9972ab3fcc3e05eef5797e1cd278d41f33cd02da8696a83f7d73a31e"
PKG_LICENSE="OSS"
PKG_SITE="http://ftp.acc.umu.se/pub/gnome/sources/at-spi2-atk/?C=M;O=D"
PKG_URL="https://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/${PKG_VERSION:0:4}/at-spi2-atk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain at-spi2-core atk libX11 libxml2"
PKG_LONGDESC="A GTK+ module that bridges ATK to D-Bus at-spi."
