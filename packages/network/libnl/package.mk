################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="libnl"
PKG_VERSION="3.4.0"
PKG_SHA256="b7287637ae71c6db6f89e1422c995f0407ff2fe50cecd61a312b6a9b0921f5bf"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://github.com/thom311/libnl/"
PKG_URL="https://github.com/thom311/$PKG_NAME/releases/download/${PKG_NAME}${PKG_VERSION//./_}/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="libnl: libnl - netlink library"
PKG_LONGDESC="libnl is a library for applications dealing with netlink socket. It provides an easy to use interface for raw netlink message but also netlink family specific APIs."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-cli --disable-debug"
