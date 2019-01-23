# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="6e02ebc"
PKG_SHA256=""
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host re2c:host"
PKG_TOOLCHAIN="manual"

pre_configure_host() {
  export CFLAGS="-march=haswell -fstack-protector -fno-plt -Wall"
  export CXXFLAGS="-march=haswell -fstack-protector -fno-plt -Wall"
  export LDFLAGS="-march=haswell -Wl,-z,relro -Wl,-z,now -s"
}

make_host() {
  python2 configure.py --bootstrap --verbose
# CXX=/bin/clang++ | $TOOLCHAIN/bin/python2
# python2 configure.py --bootstrap
}

makeinstall_host() {
  cp ninja $TOOLCHAIN/bin
}