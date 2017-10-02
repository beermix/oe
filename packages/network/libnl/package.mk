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
PKG_VERSION="3.4.0-rc1"
PKG_SITE="https://github.com/thom311/libnl/releases"
PKG_URL="https://github.com/thom311/libnl/releases/download/libnl3_4_0rc1/libnl-3.4.0-rc1.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="libnl: libnl - netlink library"
PKG_LONGDESC="libnl is a library for applications dealing with netlink socket. It provides an easy to use interface for raw netlink message but also netlink family specific APIs."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --with-pic --disable-cli"

#pre_configure_target() {
#  export CFLAGS="$CFLAGS -fPIC"
#}