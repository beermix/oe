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

PKG_NAME="cups"
PKG_VERSION="v2.2.1"
PKG_SITE="http://www.cups.org"
PKG_GIT_URL="https://github.com/apple/cups"
PKG_DEPENDS_TARGET="toolchain avahi zlib libressl"
PKG_SECTION="depends"
PKG_SHORTDESC="CUPS printing system"
PKG_LONGDESC="CUPS is the standards-based, open source printing system developed by Apple Inc. for macOS® and other UNIX®-like operating sysms"

PKG_AUTORECONF="no"

pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
}

PKG_CONFIGURE_OPTS_TARGET="--libdir=/usr/lib --disable-gssapi"

makeinstall_target() {
  make BUILDROOT=$INSTALL install-headers install-libs
}
