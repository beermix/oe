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

PKG_NAME="packaging"
PKG_VERSION="19.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/packaging"
PKG_URL="https://pypi.python.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
PKG_DEPENDS_HOST="Python2:host six:host pyparsing:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="packaging: Core utilities for Python packages"
PKG_LONGDESC="Packaging is the Core utilities for Python packages package"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}
