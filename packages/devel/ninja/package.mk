# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="1db07ed"
PKG_SHA256="5cef852927283ed5e2f059f10dc21ac7eac0537b366002d9f15e003dd83edba1"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
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
