################################################################################
#      This file is part of Alex@ELEC - http://www.alexelec.in.ua
#      Copyright (C) 2011-2016 Alexandr Zuyev (alex@alexelec.in.ua)
################################################################################

PKG_NAME="xcb-util"
PKG_VERSION="0.4.0"
PKG_LICENSE="GPL"
PKG_SITE="http://xcb.freedesktop.org"
PKG_URL="http://xcb.freedesktop.org/dist/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxcb"
PKG_SHORTDESC="utility libraries for X C Binding"
PKG_LONGDESC="This package contains the library files needed to run software using libxcb utils"
PKG_TOOLCHAIN="autotools"