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

PKG_NAME="fixesproto"
PKG_VERSION="4292ec1"
#PKG_SHA256="a6cd46c37061cb401f4a599d5e87a99b2e0021760ffbe3488aacca7607bfd499"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_SOURCE_DIR="$PKG_VERSION"
PKG_URL="https://cgit.freedesktop.org/xorg/proto/fixesproto/snapshot/$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_SECTION="x11/proto"
PKG_SHORTDESC="fixesproto: Fixes extension headers"
PKG_LONGDESC="Fixes extension headers"
PKG_TOOLCHAIN="autotools"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--without-xmlto"
