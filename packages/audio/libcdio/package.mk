# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libcdio"
#PKG_VERSION="0.94"
#PKG_SHA256="96e2c903f866ae96f9f5b9048fa32db0921464a2286f5b586c0f02699710025a"
PKG_VERSION="2.0.0"
PKG_SHA256="1b481b5da009bea31db875805665974e2fc568e2b2afa516f4036733657cf958"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/libcdio/"
PKG_URL="http://ftpmirror.gnu.org/libcdio/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
#PKG_BUILD_FLAGS="+pic"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--enable-cxx \
                           --disable-cpp-progs \
                           --enable-static \
                           --enable-joliet \
                           --disable-rpath \
                           --enable-rock \
                           --disable-cddb \
                           --disable-vcd-info \
                           --without-cd-drive \
                           --without-cd-info \
                           --without-cdda-player \
                           --without-cd-read \
                           --without-iso-info \
                           --without-iso-read \
                           --without-libiconv-prefix \
                           --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
