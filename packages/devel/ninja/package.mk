# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ninja"
PKG_VERSION="ca041d8"
PKG_VERSION="253e94c"
PKG_ARCH="any"
PKG_LICENSE="Apache"
PKG_SITE="https://github.com/ninja-build/ninja"
PKG_URL="https://github.com/ninja-build/ninja/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="Python2:host Python3:host re2c:host"
PKG_SECTION="devel"
PKG_SHORTDESC="Small build system with a focus on speed"
PKG_LONGDESC="Small build system with a focus on speed"
PKG_TOOLCHAIN="manual"

#pre_configure_host() {
#  unset CPPFLAGS
#  unset CFLAGS
#  unset CXXFLAGS
#  unset LDFLAGS
#}

make_host() {
  # CXX=/usr/bin/clang++ $TOOLCHAIN/bin/python2 ./configure.py --bootstrap --verbose
  # CXX=/bin/clang++ $TOOLCHAIN/bin/python2 ./configure.py --bootstrap
  $TOOLCHAIN/bin/python2 ./configure.py --bootstrap
  # emacs -Q --batch -f batch-byte-compile misc/ninja-mode.el
}

makeinstall_host() {
  # $TOOLCHAIN/bin/python2 ./configure.py
  # ./ninja ninja_test
  # ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

  strip ninja
  cp ninja $TOOLCHAIN/bin
}