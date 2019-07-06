# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present vpeter

PKG_NAME="jdk-x86_64-zulu"
PKG_VERSION="8u212"
PKG_SHA256="568e7578f1b20b1e62a8ed2c374bad4eb0e75d221323ccfa6ba8d7bc56cf33cf"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.azul.com/products/zulu-enterprise/"
PKG_URL="https://cdn.azul.com/zulu/bin/zulu8.38.0.13-ca-jdk8.0.212-linux_x64.tar.gz"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="Zulu, the open Java(TM) platform from Azul Systems."
PKG_TOOLCHAIN="manual"

post_unpack() {
  rm -f $PKG_BUILD/src.zip
}
