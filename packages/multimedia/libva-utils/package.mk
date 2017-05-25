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

PKG_NAME="libva-utils"
PKG_VERSION="1.8.2"
PKG_SITE="https://github.com/01org/libva"
PKG_GIT_URL="https://github.com/01org/libva-utils"
PKG_DEPENDS_TARGET="toolchain readline intel-vaapi-driver"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-drm \
			      --enable-x11 \
			      --disable-wayland \
			      --enable-static \
			      --disable-shared"
