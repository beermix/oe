# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="46.1.3"
PKG_SHA256="984eeb7909fa610a441711c00dc4fa5bbf3c49f9b4b5204b56b7362bdd04f397"
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
