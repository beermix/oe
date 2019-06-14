# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="nghttp2"
PKG_VERSION="1.39.1"
PKG_SHA256="679160766401f474731fd60c3aca095f88451e3cc4709b72306e4c34cf981448"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/nghttp2/nghttp2/releases/"
PKG_URL="https://github.com/nghttp2/nghttp2/releases/download/v$PKG_VERSION/nghttp2-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="nghttp2 is an implementation of HTTP/2 and its header compression algorithm, HPACK."
PKG_TOOLCHAIN="configure"
PKG_TOOLCHAIN="cmake-make"

PKG_CONFIGURE_OPTS_TARGET="--enable-lib-only"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DENABLE_LIB_ONLY=1"

post_makeinstall_target() {
  rm -r "${INSTALL}/usr/share"
}
