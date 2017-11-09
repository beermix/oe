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

PKG_NAME="apsw"
PKG_VERSION="148658c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/rogerbinns/apsw"
PKG_URL="https://github.com/rogerbinns/apsw/archive/${PKG_VERSION}.tar.gz"
#PKG_URL="https://github.com/rogerbinns/apsw/releases/download/$PKG_VERSION/apsw-$PKG_VERSION.zip"
PKG_DEPENDS_TARGET="Python2 sqlite"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="Mako: A super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_LONGDESC="Mako is a super-fast templating language that borrows the best ideas from the existing templating languages."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

export CCACHE_DISABLE=1

make_target() {
  : python2 setup.py build --help
}

makeinstall_target() {
  python setup.py install --skip-build
}

