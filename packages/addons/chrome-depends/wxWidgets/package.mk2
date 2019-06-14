################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
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
PKG_NAME="wxWidgets"
PKG_VERSION="3.1.1"
PKG_SITE="https://github.com/wxWidgets/wxWidgets"
#PKG_URL="https://github.com/wxWidgets/wxWidgets/releases/download/v$PKG_VERSION/wxWidgets-$PKG_VERSION.tar.bz2"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain gtk+ libSM tiff libpng gst-plugins-base"
PKG_SECTION="depends"
PKG_SHORTDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_LONGDESC="A cross-platform GUI and tools library for GTK, MS Windows, and MacOS."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--with-gtk=2 \
			      --with-opengl \
			      --enable-unicode \
			      --enable-graphics_ctx \
			      --with-regex=builtin \
			      --with-libpng \
			      --with-libjpeg \
			      --with-libtiff \
			      --disable-precomp-headers \
			      --disable-shared"

post_makeinstall_target() {
  ln -sf wx-config $TOOLCHAIN/bin/wx-config
  #sed -e "s:\(['= ]\)/usr:\\1$SYSROOT_PREFIX/usr:g" -i $SYSROOT_PREFIX/usr/bin/wx-config
}