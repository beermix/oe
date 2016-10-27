################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, 
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="syncthing"
PKG_VERSION="0.11.9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://syncthing.net/"
PKG_URL="https://github.com/syncthing/syncthing/releases/download/v0.11.9/syncthing-linux-amd64-v$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python"
PKG_PRIORITY="optional"
PKG_SECTION="service/sync_service"
PKG_SHORTDESC="Syncthing: Open source synchronisation tool"
PKG_LONGDESC="Syncthing replaces proprietary sync and cloud services 
with something open, trustworthy and decentralized. Your data is your 
data alone and you deserve to choose where it is stored, if it is 
shared with some third party and how it's transmitted over the 
Internet."

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""

PKG_AUTORECONF="yes"


PKG_MAINTAINER="unofficial.addon.pro"

makeinstall_target() {
  : # nop
}

addon(){
	mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -P $PKG_BUILD/.$TARGET_NAME/syncthing 
$ADDON_BUILD/$PKG_ADDON_ID/bin
}
