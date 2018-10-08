# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libva-utils"
PKG_VERSION="2.3.0"
PKG_SHA256="f338497b867bbc9bf008e4892eaebda08955785dc7eb2005855bba5f1a20b037"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/01org/libva-utils"
PKG_URL="https://github.com/intel/libva-utils/archive/$PKG_VERSION.tar.gz"
PKG_SECTION="debug"
PKG_SHORTDESC="Libva-utils is a collection of tests for VA-API (VIdeo Acceleration API)"
PKG_LONGDESC="Libva-utils is a collection of tests for VA-API (VIdeo Acceleration API)"
HARDENING_SUPPORT="yes"

PKG_MESON_OPTS_TARGET="-Ddrm=true \
			  -Dx11=true \
			  -Dwayland=false \
			  -Dtests=false"