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

PKG_NAME="Pillow"
PKG_VERSION="4.0.0"
PKG_SITE="http://www.pythonware.com/products/pil/"
PKG_URL="https://pypi.python.org/packages/8d/80/eca7a2d1a3c2dafb960f32f844d570de988e609f5fd17de92e1cf6a01b0a/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host zlib freetype openjpeg tiff"
PKG_SECTION="python"
PKG_SHORTDESC="pil: Imaging handling/processing for Python"
PKG_LONGDESC="The Python Imaging Library (PIL) adds image processing capabilities to your Python interpreter. This library supports many file formats, and provides powerful image processing and graphics capabilities."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  python setup.py build_ext --disable-platform-guessing
}

makeinstall_target() {
  python setup.py install --root=$INSTALL --prefix=/usr
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"

  rm -rf $INSTALL/usr/bin
}
