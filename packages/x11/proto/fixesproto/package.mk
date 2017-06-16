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

PKG_NAME="fixesproto"
PKG_VERSION="4292ec1c63180c5f4e7c0e606fa68c51913f172b"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_GIT_URL="https://anongit.freedesktop.org/git/xorg/proto/fixesproto"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_PRIORITY="optional"
PKG_SECTION="x11/proto"
PKG_SHORTDESC="fixesproto: Fixes extension headers"
PKG_LONGDESC="Fixes extension headers"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  # unset LIBTOOL because freetype uses its own
    ( cd ..
      unset LIBTOOL
      NOCONFIGURE=1 ./autogen.sh
    )
}