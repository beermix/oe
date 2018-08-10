# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="populatefs"
PKG_VERSION="b2d52d4"
PKG_SHA256="13711225888e5e15b14007cf834b34b913d65f6f628483eb052e64180bd31f5a"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lipnitsk/populatefs"
PKG_URL="https://github.com/kfix/populatefs/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="e2fsprogs:host"
PKG_SECTION="tools"
PKG_SHORTDESC="populatefs: Tool for replacing genext2fs when creating ext4 images"
PKG_LONGDESC="populatefs: Tool for replacing genext2fs when creating ext4 images"
PKG_BUILD_FLAGS="+pic:host"

make_host() {
  make EXTRA_LIBS="-lcom_err -lpthread"
}

makeinstall_host() {
  $STRIP src/populatefs

  mkdir -p $TOOLCHAIN/sbin
  cp src/populatefs $TOOLCHAIN/sbin
}
