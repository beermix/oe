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
################################################################################ bc:host libelf:host nasm:host re2c:host

PKG_NAME="toolchain"
PKG_VERSION=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://libreelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="configtools:host make:host xz:host sed:host pkg-config:host autoconf:host automake:host intltool:host libtool:host autoconf-archive:host bison:host flex:host mpc:host cmake:host xmlstarlet:host yasm:host re2c:host ninja:host meson:host bc:host "
PKG_SECTION="virtual"
PKG_SHORTDESC="toolchain: LibreELEC.tv' toolchain"
PKG_LONGDESC="a crosscompiling toolchain to compile all packages"
