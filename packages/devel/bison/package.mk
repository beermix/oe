# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bison"
PKG_VERSION="3.4.2"
PKG_SHA256="27d05534699735dc69e86add5b808d6cb35900ad3fd63fa82e3eb644336abfa0"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/bison/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host flex:host"
PKG_LONGDESC="A general-purpose parser generator."

PKG_CONFIGURE_OPTS_HOST="--disable-rpath --with-gnu-ld"

