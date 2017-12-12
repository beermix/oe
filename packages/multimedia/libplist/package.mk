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

PKG_NAME="libplist"
PKG_VERSION="2.0.0"
PKG_SITE="http://matt.colyer.name/projects/iphone-linux/"
PKG_URL="http://www.libimobiledevice.org/downloads/libplist-2.0.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2 glib"
PKG_SECTION="devel"
PKG_SHORTDESC="libplist: a library for manipulating Apple Binary and XML Property Lists"
PKG_LONGDESC="libplist is a library for manipulating Apple Binary and XML Property Lists"

PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--without-cython --disable-shared --with-pic"

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#}
