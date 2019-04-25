# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson"
PKG_VERSION="0.50.1"
PKG_SHA256="f68f56d60c80a77df8fc08fa1016bc5831605d4717b622c96212573271e14ecc"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/mesonbuild/meson/releases"
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
