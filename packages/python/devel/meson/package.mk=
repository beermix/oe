################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="meson"
PKG_VERSION="0.43.0"
PKG_SHA256="c513eca90e0d70bf14cd1eaafea2fa91cf40a73326a7ff61f08a005048057340"
PKG_ARCH="any"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/mesonbuild/meson/releases/"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host pathlib:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="High productivity build system"
PKG_LONGDESC="High productivity build system"

make_host() {
  python3 setup.py build
}

makeinstall_host() {
  python3 setup.py install --prefix=$TOOLCHAIN --skip-build
}
