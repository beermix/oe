################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="usb-modeswitch"
PKG_VERSION="2.3.0"
PKG_SHA256="f93e940c2eb0c585a5d2210177338e68a9b24f409e351e4a854132453246b894"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.draisberghof.de/usb_modeswitch/"
PKG_URL="http://www.draisberghof.de/usb_modeswitch/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libusb"
PKG_SECTION="tools"
PKG_SHORTDESC="USB_ModeSwitch - Handling Mode-Switching USB Devices on Linux"
PKG_LONGDESC="USB_ModeSwitch - Handling Mode-Switching USB Devices on Linux"

makeinstall_target() {
  : # nop
}
