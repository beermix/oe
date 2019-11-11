# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
#PKG_VERSION="1.9.0"
#PKG_SHA256="5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9"
PKG_VERSION="3ef623a"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="cmake:host Python2:host Python3:host re2c:host"
PKG_TOOLCHAIN="manual"
PKG_TOOLCHAIN="cmake-make"

configure_package() {
   PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS=-s"
}

makeinstall_host() {
  cp $PKG_BUILD/.$HOST_NAME/ninja $TOOLCHAIN/bin
#  strip $TOOLCHAIN/bin/ninja
}
