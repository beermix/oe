# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="parallel"
PKG_VERSION="7aa0394278b6abb439ba6e333f7a80120efa8762"
PKG_SHA256="a4a78490803bd6e0f6916fb7bf26a1aa1ca0080f998f582551f79e4c18b6d9a0"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/parallel/"
PKG_URL="http://ftpmirror.gnu.org/parallel/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_URL="https://git.savannah.gnu.org/cgit/parallel.git/snapshot/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_LONGDESC="GNU parallel is a shell tool for executing jobs in parallel using one or more computers."

PKG_TOOLCHAIN="manual"

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp $PKG_BUILD/src/parallel $TOOLCHAIN/bin
}