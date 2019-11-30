# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="stress-ng"
PKG_VERSION="0.10.12"
PKG_SHA256="0813ab7efb32ed56acb305e3843158e98f01f996da0b371da8829f502b5e6fa8"
PKG_LICENSE="GPLv2"
PKG_SITE="http://kernel.ubuntu.com/~cking/stress-ng/"
PKG_URL="http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain attr keyutils libaio libcap zlib"
PKG_LONGDESC="stress-ng will stress test a computer system in various selectable ways"
PKG_TOOLCHAIN="make"

make_target() {
  STATIC=0 make
}