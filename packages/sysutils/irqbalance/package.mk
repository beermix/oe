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

PKG_NAME="irqbalance"
PKG_VERSION="aa04f78"
PKG_REV="1"
PKG_ARCH="i386 x86_64 arm"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/Irqbalance/irqbalance"
PKG_GIT_URL="https://github.com/Irqbalance/irqbalance.git"
PKG_GIT_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain glib systemd"

PKG_SECTION="system"
PKG_SHORTDESC="irqbalance: a daemon to help balance the cpu load generated by interrupts across all of a systems cpus"
PKG_LONGDESC="irqbalance is a daemon to help balance the cpu load generated by interrupts across all of a systems cpus."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--with-systemd --with-glib2 --without-libcap-ng"

post_makeinstall_target() {
  mkdir -p $INSTALL/etc
    cp $ROOT/$PKG_BUILD/misc/irqbalance.env $INSTALL/etc/irqbalance

  mkdir -p $INSTALL/usr/lib/systemd/system
    cp $ROOT/$PKG_BUILD/misc/irqbalance.service $INSTALL/usr/lib/systemd/system
}

post_install() {
  enable_service irqbalance.service
}
