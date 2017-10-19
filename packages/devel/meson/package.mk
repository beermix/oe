################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="meson"
PKG_VERSION="0.43.0"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/$PKG_VERSION/meson-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host pathlib:host"
PKG_SECTION="devel"
PKG_SHORTDESC="Small build system with a focus on speed"
PKG_LONGDESC="Small build system with a focus on speed"

PKG_AUTORECONF="no"

configure_host() {
  :
}

make_host() {
  python3 setup.py build
}

makeinstall_host() {
  python3 setup.py install --prefix=$TOOLCHAIN
}