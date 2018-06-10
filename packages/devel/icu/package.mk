################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="icu"
PKG_VERSION="61.1"
#PKG_SHA256="2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://www.icu-project.org"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
#PKG_URL="http://192.168.1.200:8080/%2Ficu4c-54_1-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain libiconv icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_BUILD_FLAGS="+pic"

post_unpack() {
  sed -i 's/xlocale/locale/' $PKG_BUILD/source/i18n/digitlst.cpp
  #mv $PKG_BUILD/source/* $PKG_BUILD
  #rmdir $PKG_BUILD/source
}

#post_configure_host() {
  # we are not in source folder
 # sed -i 's|../LICENSE|LICENSE|' Makefile
#}

#post_configure_target() {
  # same as above
#  post_configure_host --with-data-packaging=archive
#}

makeinstall_host() {
  : # not required
}

PKG_CONFIGURE_SCRIPT="source/configure"

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--with-cross-build=$(get_build_dir $PKG_NAME)/.$HOST_NAME \
                             --enable-static \
                             --disable-shared"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}
