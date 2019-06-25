# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ninja"
PKG_VERSION="e6aeab8"
PKG_SHA256="ad0fb5c4d25fc1901632b037ab7ecc178dcdb6b3183410e8884562a302c80609"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/v$PKG_VERSION.tar.gz"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host re2c:host"
PKG_TOOLCHAIN="manual"

pre_configure_host() {
  export LDFLAGS="$LDFLAGS -s"
}

make_host() {
  python2 configure.py --bootstrap --verbose
# CXX=/bin/clang++ | $TOOLCHAIN/bin/python2
# python2 configure.py --bootstrap
}

makeinstall_host() {
  cp ninja $TOOLCHAIN/bin
}
