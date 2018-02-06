################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="icu"
PKG_VERSION="60.2"
PKG_SHA256="f073ea8f35b926d70bb33e6577508aa642a8b316a803f11be20af384811db418"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://www.icu-project.org"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"

post_unpack() {
  sed -i 's/xlocale/locale/' $PKG_BUILD/source/i18n/digitlst.cpp
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
}

configure_host() {
 cd $PKG_BUILD
 ./runConfigureICU Linux/gcc \
 		     CC=$HOST_CC \
 		     CXX=$HOST_CXX \
 		     --disable-debug \
 		     --enable-release \
 		     --disable-shared \
 		     --enable-static \
 		     --enable-draft \
 		     --enable-renaming \
 		     --disable-tracing \
 		     --disable-extras \
 		     --enable-dyload \
 		     --prefix=$TOOLCHAIN
}

configure_target() {
 cd $PKG_BUILD
 ./runConfigureICU Linux/gcc \
 		     CC=$CC \
 		     CXX=$CXX \
 		     --target=$TARGET_NAME \
 		     --build=$TARGET_NAME \
 		     --host=$TARGET_NAME \
 		     --disable-debug \
 		     --enable-release \
 		     --disable-shared \
 		     --enable-static \
 		     --enable-draft \
 		     --enable-renaming \
 		     --disable-tracing \
 		     --disable-extras \
 		     --enable-dyload \
 		     --disable-tools \
 		     --disable-tests \
 		     --disable-samples \
 		     --with-cross-build=$PKG_BUILD/.$HOST_NAME
}

post_makeinstall_target() {
  rm -rf $INSTALL
}