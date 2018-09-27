# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="40.4.3"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://github.com/pypa/setuptools/releases"
PKG_URL="https://github.com/pypa/setuptools/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host Python3:host six:host packaging:host appdirs:host"
PKG_DEPENDS_TARGET="toolchain Python2 setuptools:host"
PKG_SECTION="python/devel"
PKG_SHORTDESC="setuptools: A collection of enhancements to the Python distutils"
PKG_LONGDESC="Distribute is intended to replace Setuptools as the standard method for working with Python module distributions. Packages built and distributed using distribute look to the user like ordinary Python packages based on the distutils. Your users don't need to install or even know about setuptools in order to use them, and you don't have to include the entire setuptools package in your distributions. By including just a single bootstrap module (a 7K .py file), your package will automatically download and install setuptools if the user is building your package from source and doesn't have a suitable version already installed."
PKG_TOOLCHAIN="manual"

make_host() {
  python bootstrap.py
}

makeinstall_host() {
  python2 setup.py install --prefix=$TOOLCHAIN
  python3 setup.py install --prefix=$TOOLCHAIN
}

makeinstall_target() {
  python2 setup.py install --root=$INSTALL --prefix=/usr --force
  python3 setup.py install --root=$INSTALL --prefix=/usr --force
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
  rm -rf $INSTALL/usr/lib/python*/site-packages/*.egg-info
}
