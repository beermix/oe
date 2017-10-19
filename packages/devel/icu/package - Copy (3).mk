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
PKG_VERSION="57.1U"
PKG_SITE="http://download.icu-project.org/files/icu4c/?C=M;O=D"
PKG_URL="https://dl.dropboxusercontent.com/s/z3y8na4bk0d7t0h/icu-57.1U.tar.xz"
#PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu:host"
PKG_SECTION="textproc"
PKG_SHORTDESC="International Components for Unicode library"
PKG_LONGDESC="International Components for Unicode library"

PKG_AUTORECONF="no"

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC"
  CXXFLAGS="$CXXFLAGS -fPIC"
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