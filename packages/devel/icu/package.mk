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
}

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
#  LIBS="$LIBS -latomic"
}

PKG_CONFIGURE_OPTS_HOST="--disable-debug \
			    --enable-release \
			    --disable-shared \
			    --enable-static \
			    --enable-draft \
			    --enable-renaming \
			    --disable-tracing \
			    --disable-extras \
			    --enable-dyload"
			   
PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
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
			      --with-cross-build=$PKG_BUILD/.$HOST_NAME"

PKG_CONFIGURE_SCRIPT="source/configure"

post_makeinstall_target() {
  rm -rf $INSTALL
}