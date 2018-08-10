# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="rpcsvc-proto"
PKG_VERSION="1.4"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://sourceforge.net/projects/libtirpc/"
PKG_URL="https://github.com/thkukuk/rpcsvc-proto/releases/download/v$PKG_VERSION/rpcsvc-proto-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="libtirpc: Transport Independent RPC Library"
PKG_LONGDESC="Libtirpc is a port of Suns Transport-Independent RPC library to Linux. It's being developed by the Bull GNU/Linux NFSv4 project."
PKG_TOOLCHAIN="autotools"