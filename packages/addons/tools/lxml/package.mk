################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="lxml"
PKG_VERSION="4.0.0"
PKG_REV="100"
PKG_LICENSE="BSD"
PKG_SITE="http://lxml.de/"
PKG_URL="https://github.com/lxml/$PKG_NAME/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="lxml-$PKG_NAME-$PKG_VERSION"
PKG_DEPENDS_TARGET="cython:host libxslt:host libxml2 libxslt"
PKG_IS_PYTHON="yes"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="lxml"
PKG_ADDON_TYPE="xbmc.python.module"
PKG_SECTION="script.module"
PKG_SHORTDESC="$PKG_ADDON_NAME: XML and HTML with Python"
PKG_LONGDESC="$PKG_ADDON_NAME ($PKG_REV) is the most feature-rich and easy-to-use library for processing XML and HTML in the Python language"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $PKG_BUILD/.install_pkg/usr/lib/python*/site-packages/* \
         $ADDON_BUILD/$PKG_ADDON_ID/lib
}
