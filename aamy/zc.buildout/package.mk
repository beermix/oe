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

PKG_NAME="zc.buildout"
PKG_VERSION="2.4.3"
PKG_SITE="https://pypi.python.org/pypi/PyAMF/"
PKG_URL="https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-2.4.3.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python distutilscross:host cffi libffi"
PKG_SECTION="python/system"



pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  export PYTHONXCPREFIX="$SYSROOT_PREFIX/usr"
}

make_target() {
wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh; chmod +x Miniconda3-latest-Linux-x86_64.sh
}

makeinstall_target() {
./Miniconda3-latest-Linux-x86_64.sh -p -b /root/oe/build.OpenELEC-Generic.x86_64-6.0-devel/zc.buildout-2.4.3/.install_pkg
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
}
