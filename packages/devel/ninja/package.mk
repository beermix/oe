# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="1.9.0"
PKG_SHA256="5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host re2c:host"
PKG_TOOLCHAIN="manual"

pre_configure_host() {
  export LDFLAGS="-s"
}

make_host() {
  python2 configure.py --bootstrap
# CXX=/bin/clang++ | $TOOLCHAIN/bin/python2
# python2 configure.py --bootstrap
}

makeinstall_host() {
  cp ninja $TOOLCHAIN/bin
}
