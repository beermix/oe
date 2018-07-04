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
PKG_VERSION="62.1"
#PKG_SHA256="2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
PKG_ARCH="any"
PKG_LICENSE="Custom"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain libiconv icu:host"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_BUILD_FLAGS="+pic"
#PKG_TOOLCHAIN="configure"

post_unpack() {
 # sed -i 's/xlocale/locale/' $PKG_BUILD/source/i18n/digitlst.cpp
  cp -r $PKG_BUILD/source/* $PKG_BUILD/
}

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
  CXXFLAGS="$CXXFLAGS -std=c++11"
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
  LIBS="-latomic"
  CXXFLAGS="$CXXFLAGS -std=c++11"
}

configure_host() {
 cd $PKG_BUILD/.$HOST_NAME
 ./runConfigureICU Linux/gcc \
 		     CC="$HOST_CC" \
 		     CXX="$HOST_CXX" \
 		     --disable-samples \
 		     --disable-tests \
 		     --disable-extras \
 		     --disable-icuio \
 		     --disable-layout \
 		     --disable-renaming \
 		     --disable-silent-rules \
 		     --prefix=$TOOLCHAIN
}

configure_target() {
 cd $PKG_BUILD/.$TARGET_NAME
 ./runConfigureICU Linux/gcc \
 		     CPP="$CPP" \
 		     CC="$CC" \
 		     CXX="$CXX" \
 		     --prefix=/usr \
 		     --disable-shared \
 		     --enable-static \
 		     --disable-silent-rules \
 		     --with-cross-build="$PKG_BUILD/.$HOST_NAME"
}

post_makeinstall_target() {
  rm -rf $INSTALL
}