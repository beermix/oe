################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2013 Dag Wieers (dag@wieers.com)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="slang"
PKG_VERSION="2.3.1a"
PKG_SITE="http://www.jedsoft.org/slang"
PKG_URL="http://www.jedsoft.org/releases/slang/slang-2.3.1a.tar.bz2"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_SECTION="xmedia/depends"
PKG_SHORTDESC="slang: library for the S-Lang extension language"
PKG_LONGDESC="S-Lang is an interpreted language and a programming library.  The S-Lang language was designed so that it can be easily embedded into a program to provide the program with a powerful extension language.  The S-Lang library, provided in this package, provides the S-Lang extension language.  S-Lang's syntax resembles C, which makes it easy to recode S-Lang procedures in C if you need to."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_make_target() {
  # dont build parallel
  MAKEFLAGS=-j1
}

configure_target() {
  ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --prefix=/usr \
              --without-x
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/etc
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/usr/lib/slang
}
