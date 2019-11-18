# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
#PKG_VERSION="1.9.0"
#PKG_SHA256="5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9"
PKG_VERSION="2d15b04"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/v$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host re2c:host"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"

makeinstall_host() {
  cp $PKG_BUILD/.$HOST_NAME/ninja $TOOLCHAIN/bin
  strip -s $TOOLCHAIN/bin/ninja
}

#make_host() {
#  CXX=clang++ python3 configure.py --bootstrap
# CXX=clang++ | $TOOLCHAIN/bin/python2
#}

#makeinstall_host() {
#  cp ninja $TOOLCHAIN/bin
#  strip $TOOLCHAIN/bin/ninja
#}
