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

# with 1.0.0 repeat delay is broken. test on upgrade

PKG_NAME="v4l-utils"
PKG_VERSION="1.12.5"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://linuxtv.org/downloads/v4l-utils/?C=M;O=D"
PKG_URL="http://linuxtv.org/downloads/v4l-utils/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="v4l-utils: Linux V4L2 and DVB API utilities and v4l libraries (libv4l)."
PKG_LONGDESC="Linux V4L2 and DVB API utilities and v4l libraries (libv4l)."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-v4l-utils"


post_makeinstall_target() {
  #rm -rf $INSTALL/etc/rc_keymaps
   # ln -sf /storage/.config/rc_keymaps $INSTALL/usr/config/rc_keymaps

  mkdir -p $INSTALL/usr/config
    cp -PR $PKG_DIR/config/* $INSTALL/usr/config

  rm -rf $INSTALL/usr/lib/udev/rules.d
    mkdir -p $INSTALL/usr/lib/udev/rules.d
    cp -PR $PKG_DIR/udev.d/*.rules $INSTALL/usr/lib/udev/rules.d
}
