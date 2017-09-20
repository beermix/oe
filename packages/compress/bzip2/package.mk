################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="bzip2"
PKG_VERSION="0496eaa"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.oberhumer.com/opensource/lzo"
PKG_GIT_URL="https://github.com/osrf/bzip2_cmake"
PKG_DEPENDS_TARGET="toolchain bzip2:host"
PKG_PRIORITY="optional"
PKG_SECTION="compress"

PKG_USE_CMAKE="yes"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
}

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}
