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

PKG_NAME="lcms2"
PKG_VERSION="29b019f"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/mm2/Little-CMS/releases"
PKG_URL="https://github.com/mm2/Little-CMS/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="Little-CMS-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain zlib libjpeg-turbo tiff"
PKG_SECTION="devel"
PKG_SHORTDESC="lcms2: small-footprint color management engine"
PKG_LONGDESC="lcms2 is a Small-footprint color management engine."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-zlib \
			      --with-threads \
			      --with-jpeg \
			      --with-tiff"

