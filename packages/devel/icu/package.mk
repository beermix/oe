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
PKG_VERSION="59.1"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="http://download.icu-project.org/files/${PKG_NAME}4c/${PKG_VERSION}/${PKG_NAME}4c-${PKG_VERSION//./_}-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

#post_unpack() {
#  sed -i 's/xlocale/locale/' $ROOT/$PKG_BUILD/source/i18n/digitlst.cpp
#}

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
  LIBS="$LIBS -latomic"
}

PKG_CONFIGURE_SCRIPT="source/configure"

PKG_CONFIGURE_OPTS_HOST="--disable-samples \
			    --disable-tests \
			    --disable-extras \
			    --disable-icuio \
			    --disable-layout \
			    --disable-renaming"
			   
PKG_CONFIGURE_OPTS_TARGET="--disable-samples \
			      --disable-tests \
			      --disable-shared \
			      --with-cross-build=$ROOT/$PKG_BUILD/.$HOST_NAME"

makeinstall_host() {
  : # nop
}			      

post_makeinstall_target() {
  rm -rf $INSTALL
}