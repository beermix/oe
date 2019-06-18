# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson"
PKG_VERSION="0.49.2"
PKG_SHA256="ef9f14326ec1e30d3ba1a26df0f92826ede5a79255ad723af78a2691c37109fd"
#PKG_VERSION="0.51.0"
#PKG_SHA256="2f75fdf6d586d3595c03a07afcd0eaae11f68dd33fea5906a434d22a409ed63f"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/mesonbuild/meson/releases"
PKG_URL="https://github.com/mesonbuild/meson/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host setuptools:host pathlib:host"
PKG_LONGDESC="High productivity build system"
PKG_TOOLCHAIN="manual"

make_host() {
  python3 setup.py build
}

makeinstall_host() {
  exec_thread_safe python3 setup.py install --prefix=$TOOLCHAIN --skip-build

  # Avoid using full path to python3 that may exceed 128 byte limit.
  # Instead use PATH as we know our toolchain is first.
  sed -e '1 s/^#!.*$/#!\/usr\/bin\/env python3/' -i $TOOLCHAIN/bin/meson
}
