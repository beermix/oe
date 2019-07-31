# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="waf"
PKG_VERSION="2.0.18"
PKG_SHA256="2e0cf83a63843da127610420cef1d3126f1187d8e572b6b3a28052fc2250d4bf"
PKG_LICENSE="MIT"
PKG_SITE="https://waf.io"
PKG_URL="https://waf.io/$PKG_NAME-$PKG_VERSION"
PKG_LONGDESC="The Waf build system"
PKG_TOOLCHAIN="manual"

unpack() {
  mkdir -p $PKG_BUILD
    cp $SOURCES/$PKG_NAME/$PKG_SOURCE_NAME $PKG_BUILD/waf
    chmod a+x $PKG_BUILD/waf
}

makeinstall_host() {
  cp -pf waf $TOOLCHAIN/bin/
}
