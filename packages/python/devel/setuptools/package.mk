# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="42.0.2"
PKG_SHA256="24d07d1053431afb40ba9c82cc00f08259a1e4240098358c5da9c13dc49b640d"
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
