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

PKG_NAME="tigervnc-system"
PKG_VERSION="1.8.0"
PKG_SITE="http://www.tigervnc.org"
PKG_GIT_URL="https://github.com/TigerVNC/tigervnc"
PKG_DEPENDS_TARGET="toolchain cmake:host libX11 libXdamage libXext libXtst zlib libjpeg-turbo"
PKG_SECTION="service"
PKG_SHORTDESC="TigerVNC server"


PKG_AUTORECONF="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_VIEWER=off -Wno-dev"



post_makeinstall_target() {
  rm $INSTALL/usr/bin/vncserver
  rm $INSTALL/usr/bin/vncconfig
  mkdir -p $INSTALL/usr/config
  cp $PKG_DIR/files/vncpasswd $INSTALL/usr/config/
}
