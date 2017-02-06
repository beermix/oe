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

PKG_NAME="net-snmp"
PKG_VERSION="5.7.3"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="http://www.net-snmp.org"
PKG_URL="http://sourceforge.net/projects/net-snmp/files/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="service"
PKG_SHORTDESC="Simple Network Management Protocol utilities."
PKG_LONGDESC="Simple Network Management Protocol (SNMP) is a widely used protocol for monitoring the health and welfare of network equipment."
PKG_MAINTAINER=""

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_REPOVERSION="8.0"

PKG_AUTORECONF="yes"
PKG_CONFIGURE_OPTS_TARGET="--disable-applications \
			      --disable-manuals \
			      --disable-debugging \
			      --disable-deprecated \
			      --disable-snmptrapd-subagent \
			      --disable-perl-cc-checks \
			      --with-defaults \
			      --with-perl-modules=no \
			      --enable-mini-agent \
			      --disable-embedded-perl"

make_target() {
  make
}

makeinstall_target() {
  mkdir $ROOT/$PKG_BUILD/.install
  make install INSTALL_PREFIX=$ROOT/$PKG_BUILD/.install
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID
  cp -r $PKG_BUILD/.install/usr/* $ADDON_BUILD/$PKG_ADDON_ID/
}

