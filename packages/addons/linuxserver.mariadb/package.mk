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

PKG_NAME="linuxserver.mariadb"
PKG_VERSION="24" # Update bin/docker.linuxserver.mariadb accordingly
PKG_REV="100"
PKG_ARCH="x86_64"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="docker"
PKG_SITE="https://hub.docker.com/r/linuxserver/mariadb/"
PKG_SHORTDESC="MariaDB as a Docker container"
PKG_LONGDESC="MariaDB is one of the most popular database servers in the world"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="MariaDB (linuxserver/mariadb:$PKG_VERSION)"
PKG_ADDON_PROJECTS="Generic"
PKG_ADDON_REQUIRES="service.system.docker:0.0.0"
PKG_ADDON_TYPE="xbmc.service"

make_target() {
  : #
}

makeinstall_target() {
  : #
}

addon() {
  : #
}
