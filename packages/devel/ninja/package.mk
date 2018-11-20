# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="5a78423"
PKG_SHA256="41c2f4f43fa6affcb23e837e0d662ddb4cad7d1a8b62d1850155b42acb40f022"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host re2c:host"
PKG_TOOLCHAIN="manual"

make_host() {
  python2 configure.py --bootstrap
  #CXX=/bin/clang++ | $TOOLCHAIN/bin/python2
  #python2 configure.py --bootstrap
}

makeinstall_host() {
  strip ninja
  cp ninja $TOOLCHAIN/bin
}