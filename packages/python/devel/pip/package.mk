################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="pip"
PKG_VERSION="9.0.1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.python.org/pypi/pip"
PKG_URL="https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz"
PKG_DEPENDS_HOST="Python2:host"
PKG_PRIORITY="optional"
PKG_SECTION="python/devel"
PKG_SHORTDESC="setuptools: A collection of enhancements to the Python distutils"
PKG_LONGDESC="Distribute is intended to replace Setuptools as the standard method for working with Python module distributions. Packages built and distributed using distribute look to the user like ordinary Python packages based on the distutils. Your users don't need to install or even know about setuptools in order to use them, and you don't have to include the entire setuptools package in your distributions. By including just a single bootstrap module (a 7K .py file), your package will automatically download and install setuptools if the user is building your package from source and doesn't have a suitable version already installed."




make_host() {
  : # nothing todo
}

makeinstall_host() {
  python setup.py install --prefix=$TOOLCHAIN
}