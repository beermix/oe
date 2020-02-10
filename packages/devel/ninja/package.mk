# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="9fd5d3e"
PKG_SHA256=""
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python3:host re2c:host"
PKG_LONGDESC="Small build system with a focus on speed"
PKG_TOOLCHAIN="manual"

make_host() {
  python3 $PKG_BUILD/configure.py --bootstrap
}

makeinstall_host() {
  cp $PKG_BUILD/.$HOST_NAME/ninja $TOOLCHAIN/bin
  strip -s $TOOLCHAIN/bin/ninja
}