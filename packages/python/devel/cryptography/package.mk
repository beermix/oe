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

PKG_NAME="cryptography"
PKG_VERSION="2.0.3"
PKG_SHA256="adbb7ddb9623616ea2c0354b7ce0506eee529b7f2d0e3894e513de5b8dce4ef8"
PKG_LICENSE="BSD"
PKG_SITE="https://cryptography.io/"
PKG_URL="https://github.com/pyca/$PKG_NAME/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="A package designed to expose cryptographic primitives and recipes to Python developers"

PKG_IS_PYTHON="yes"
PKG_PYTHON_DEPENDS_TARGET="asn1crypto cffi enum34 idna ipaddress six"

pre_configure_target() {
  export CC="$CC -pthread"
}
