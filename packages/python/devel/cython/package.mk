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

PKG_NAME="cython"
PKG_VERSION="0.27.3"
PKG_SHA256="648feb8a257574a3e4ef854475e7d767732ef26e870d2f9fcc1ca5b244b3ac89"
PKG_LICENSE="ASL"
PKG_SITE="https://github.com/cython/cython/releases"
PKG_URL="https://github.com/cython/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain distutilscross:host"
PKG_LONGDESC="The Cython compiler for writing C extensions for the Python language"
#PKG_TOOLCHAIN="manual"

make_host() {
  unset _python_exec_prefix _python_prefix _python_sysroot
  mkdir -p .$HOST_NAME
  cp -PR * .$HOST_NAME
  cd .$HOST_NAME
  export LDSHARED="$CC -shared"
  python setup.py build
}

makeinstall_host() {
  python setup.py install --prefix="$TOOLCHAIN"
}
