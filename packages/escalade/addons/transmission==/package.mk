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
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="transmission"
PKG_VERSION="0378ee8"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.transmissionbt.com/"
PKG_DEPENDS_TARGET="toolchain zlib openssl curl libevent"
PKG_SECTION="service/downloadmanager"
PKG_SHORTDESC="transmission: a fast, easy and free BitTorrent client"
PKG_LONGDESC="transmission is a fast, easy and free BitTorrent client"

PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_PROVIDES=""
PKG_ADDON_REPOVERSION="8.0"



PGK_CMAKE_OPTS_TARGET="-DENABLE_CLI=On -DENABLE_LIGHTWEIGHT=On"

pre_build_target() {
  git clone --recursive https://github.com/transmission/transmission $PKG_BUILD/$PKG_NAME-git
  cd $PKG_BUILD/$PKG_NAME-git
  git reset --hard $PKG_VERSION
  cd -
  mv $PKG_BUILD/$PKG_NAME-git/* $PKG_BUILD/
  rm -rf $PKG_BUILD/$PKG_NAME-git
  for a in $PKG_DIR/patches/*.patch
  do
    patch -p1 -d $PKG_BUILD < $a
  done
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-daemon $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/daemon/transmission-remote $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-create $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-edit $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $PKG_BUILD/.$TARGET_NAME/utils/transmission-show $ADDON_BUILD/$PKG_ADDON_ID/bin

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/web
  cp -R $PKG_BUILD/web/* $ADDON_BUILD/$PKG_ADDON_ID/web
  find $ADDON_BUILD/$PKG_ADDON_ID/web -name "Makefile*" -exec rm -rf {} ";"
  rm -rf $ADDON_BUILD/$PKG_ADDON_ID/web/LICENSE
}
