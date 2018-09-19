# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="ethtool"
PKG_VERSION="4.18"
PKG_SHA256="90948555d4c017561d0d8795f2dc61893a4932c0f3b85e6d422afd7031b7c110"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org/pub/software/network/ethtool/"
PKG_URL="http://www.kernel.org/pub/software/network/ethtool/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="ethtool: Display or change ethernet card settings"
PKG_LONGDESC="Ethtool is used for querying settings of an ethernet device and changing them."

#PKG_CONFIGURE_OPTS_TARGET="--enable-pretty-dump"
