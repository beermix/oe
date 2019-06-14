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

PKG_NAME="iwd"
PKG_VERSION="335ee0c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://git.kernel.org/cgit/network/wireless/iwd.git/about/"
PKG_GIT_URL="git://git.kernel.org/pub/scm/network/wireless/iwd.git"
PKG_DEPENDS_TARGET="toolchain ell"
PKG_SECTION="network"
PKG_SHORTDESC="Wireless daemon for Linux"
PKG_LONGDESC="Wireless daemon for Linux"


PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/etc/iwd"

post_unpack() {
  mkdir -p $PKG_BUILD/build-aux
}

pre_build_target() {
  cp -a $(get_build_dir ell)/ell $PKG_BUILD/
}

post_makeinstall_target() {
  mkdir -p $INSTALL/etc/dbus-1/system.d
    cp $PKG_BUILD/src/iwd-dbus.conf $INSTALL/etc/dbus-1/system.d
}

post_install() {
  enable_service iwd.service
}
