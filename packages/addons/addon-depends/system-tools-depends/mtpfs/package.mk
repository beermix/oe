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

PKG_NAME="mtpfs"
PKG_VERSION="fd3864d"
PKG_SHA256="f004136a82452d13362581277eb2496033aa13a6c3f35d0501327248f3120456"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.adebenham.com/mtpfs/"
PKG_URL="https://github.com/cjd/mtpfs/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse libmtp glib"
PKG_SECTION="tools"
PKG_SHORTDESC="MTPfs is a FUSE filesystem that supports reading and writing from any MTP device"
PKG_LONGDESC="MTPfs is a FUSE filesystem that supports reading and writing from any MTP device"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-mad"

# TODO: mtpfs runs host utils while building, fix and set PKG_ARCH="any"

pre_configure_target() {
  export LIBS="-lusb-1.0 -ludev"
}

makeinstall_target() {
  : # nop
}
