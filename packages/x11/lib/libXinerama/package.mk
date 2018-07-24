################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="libXinerama"
PKG_VERSION="1.1.4"
PKG_SHA256="0008dbd7ecf717e1e507eed1856ab0d9cf946d03201b85d5dcf61489bb02d720"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXext"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="libXinerama: The Xinerama library."
PKG_LONGDESC="libXinerama is the Xinerama library."

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull"
