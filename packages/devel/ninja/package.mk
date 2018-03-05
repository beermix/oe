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
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.  --verbose
################################################################################

PKG_NAME="ninja"
PKG_VERSION="e234a7b"
PKG_ARCH="any"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host Python3:host re2c:host"
PKG_SECTION="devel"
PKG_SHORTDESC="Small build system with a focus on speed"
PKG_LONGDESC="Small build system with a focus on speed"
PKG_TOOLCHAIN="manual"

make_host() {
 CXX=/usr/bin/clang++ python3 ./configure.py --bootstrap
}

makeinstall_host() {
  cp ninja $TOOLCHAIN/bin/
}
