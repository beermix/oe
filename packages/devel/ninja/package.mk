# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="ca08c43"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host re2c:host"
PKG_TOOLCHAIN="cmake-make"
#PKG_TOOLCHAIN="manual"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"

#make_host() {
#  python3 $PKG_BUILD/configure.py --bootstrap
#}

makeinstall_host() {
  cp $PKG_BUILD/.$HOST_NAME/ninja $TOOLCHAIN/bin
  strip -s $TOOLCHAIN/bin/ninja
}