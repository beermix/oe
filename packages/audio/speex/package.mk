# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="speex"
PKG_VERSION="1.2rc2"
PKG_SHA256="caa27c7247ff15c8521c2ae0ea21987c9e9710a8f2d3448e8b79da9806bce891"
PKG_LICENSE="BSD"
PKG_SITE="https://speex.org"
PKG_URL="http://downloads.us.xiph.org/releases/speex/speex-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="An Open Source Software patent-free audio compression format designed for speech."

PKG_CONFIGURE_OPTS_TARGET="--enable-sse"
