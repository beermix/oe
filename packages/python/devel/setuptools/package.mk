# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="42.0.1"
PKG_SHA256="443cab2104c90138c2e5e9b342797ecfceb2019bac284f45c29d6d697ce59dd6"
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
