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

PKG_NAME="systemd-tools"
PKG_VERSION="0"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="systemd"
PKG_SECTION="system"
PKG_SHORTDESC="This addon provides extra systemd utilities"
PKG_LONGDESC="This addon provides extra systemd utilities"


PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="7.0"

PKG_SECTION="tools"
PKG_MAINTAINER="Lukas Rusak (lorusak@gmail.com)"

unpack() {
  :
}

configure_target() {
  :
}

make_target() {
  :
}

makeinstall_target() {
  :
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -a $BUILD/systemd-[0-9]*/.$TARGET_NAME/systemd-nspawn $ADDON_BUILD/$PKG_ADDON_ID/bin/
}
