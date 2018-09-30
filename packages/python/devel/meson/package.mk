# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson"
PKG_VERSION="0.48.0"
#PKG_SHA256="92d8afd921751261e36151643464efd3394162f69efbe8cd53e0a66b1cf395eb"
PKG_ARCH="any"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/mesonbuild/meson/releases/"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host pathlib:host setuptools:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="High productivity build system"
PKG_LONGDESC="High productivity build system"
PKG_TOOLCHAIN="manual"

post_unpack() {
  cd $PKG_BUILD
  mv -v 'test cases/failing/85 gtest dependency with version' 'test cases/frameworks/'
}

make_host() {
  python3 setup.py build
  #LC_CTYPE=en_US.UTF-8 ./run_tests.py
}

makeinstall_host() {
  python3 setup.py install --prefix=$TOOLCHAIN --skip-build --optimize=1

  #--root="${pkgdir}" --optimize=1 --skip-build
  # Avoid using full path to python3 that may exceed 128 byte limit.
  # Instead use PATH as we know our toolchain is first.
  for f in meson mesonconf mesontest mesonintrospect wraptool; do
    sed -i '1 s/^#!.*$/#!\/usr\/bin\/env python3/' $TOOLCHAIN/bin/$f
  done
}
