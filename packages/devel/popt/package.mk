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

PKG_NAME="popt"
PKG_VERSION="1.16"
PKG_SITE="http://rpm5.org/"
PKG_URL="http://rpm5.org/files/popt/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="popt: contains the popt libraries which are used by some programs to parse command-line options"
PKG_LONGDESC="The popt package contains the popt libraries which are used by some programs to parse command-line options."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
}

pre_configure_target() {
 cd $PKG_BUILD
 rm -rf .$TARGET_NAME
}

pre_configure_host() {
 cd $PKG_BUILD
 rm -rf .$HOST_NAME
}
