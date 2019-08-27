# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="41.2.0"
PKG_SHA256="105a9c7aa14be6b9924c29e8d3892c23d3be1613ef3a55eaafc5cf0fc46cbddc"
PKG_LICENSE="OSS"
PKG_SITE="http://github.com/pypa/setuptools/releases"
PKG_URL="https://github.com/pypa/setuptools/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host Python3:host"
PKG_LONGDESC="Replaces Setuptools as the standard method for working with Python module distributions."
PKG_TOOLCHAIN="manual"

make_host() {
  python2 bootstrap.py
  python3 bootstrap.py
}

makeinstall_host() {
  exec_thread_safe python2 setup.py install --prefix=$TOOLCHAIN
  exec_thread_safe python3 setup.py install --prefix=$TOOLCHAIN
}

makeinstall_target() {
  exec_thread_safe python2 setup.py install --root=$INSTALL --prefix=/usr --force
  exec_thread_safe python3 setup.py install --root=$INSTALL --prefix=/usr --force
}

post_makeinstall_target() {
  find $INSTALL/usr/lib -name "*.py" -exec rm -rf "{}" ";"
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/python*/site-packages/*/tests
  rm -rf $INSTALL/usr/lib/python*/site-packages/*.egg-info
}
