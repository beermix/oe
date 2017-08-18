################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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
PKG_VERSION="cc43653"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.jedsoft.org/slang/"
PKG_GIT_URL="git://git.jedsoft.org/git/slang.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="slang: library for the S-Lang extension language"
PKG_LONGDESC="S-Lang is an interpreted language and a programming library.  The S-Lang language was designed so that it can be easily embedded into a program to provide the program with a powerful extension language.  The S-Lang library, provided in this package, provides the S-Lang extension language.  S-Lang's syntax resembles C, which makes it easy to recode S-Lang procedures in C if you need to."
PKG_IS_ADDON="no"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

MAKEFLAGS="-j1"

PKG_CONFIGURE_OPTS_TARGET="--without-iconv \
                           --without-onig \
                           --without-pcre \
                           --without-png \
                           --without-z \
                           --without-x"

PKG_MAKE_OPTS_TARGET="-C src static "

pre_configure_target() {
 # slang fails to build in subdirs
 cd $ROOT/$PKG_BUILD
 rm -rf .$TARGET_NAME
 
 #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-Os|g"`
}

makeinstall_target() {
  make DESTDIR="$SYSROOT_PREFIX" -C src install-static -j1
  make DESTDIR="$SYSROOT_PREFIX" install-pkgconfig -j1
}