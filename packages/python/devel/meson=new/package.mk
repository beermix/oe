# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson"
PKG_VERSION="0.48.2"
PKG_SHA256="39ead8bfd0dc9c7b0af15e23ea975c864600bf871fba279c9918625bb9a85506"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/mesonbuild/meson/releases/"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host pathlib:host setuptools:host"
PKG_LONGDESC="High productivity build system"
PKG_TOOLCHAIN="manual"

make_host() {
  python3 setup.py build
}

makeinstall_host() {
  python3 setup.py install --prefix=$TOOLCHAIN --skip-build

  # Avoid using full path to python3 that may exceed 128 byte limit.
  # Instead use PATH as we know our toolchain is first.
  for f in meson; do
    sed -i '1 s/^#!.*$/#!\/usr\/bin\/env python3/' $TOOLCHAIN/bin/$f
  done
}
