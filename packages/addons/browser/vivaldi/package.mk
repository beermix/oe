################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
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

PKG_NAME="vivaldi"
PKG_VERSION="1.14.1077."
PKG_SITE="http://links.twibright.com/"
PKG_URL="https://vivaldi.com/source/vivaldi-source_$PKG_VERSION.tar.xz"
PKG_BUILD_DIR="vivaldi-source"
PKG_SECTION="browser"
PKG_SHORTDESC="Links web browser plugin for OpenELEC"
PKG_LONGDESC="Links is a popular small-footprint graphics and text mode privacy-oriented web browser, released under GPL. Visit http://www.antiprism.ca for more privacy tools."
PKG_MAINTAINER="AntiPrism.ca (antiprism@antiprism.ca)"
PKG_DISCLAIMER="this is an unofficial addon. please don't ask for support in openelec forum / irc channel"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.script"


PKG_CONFIGURE_OPTS_TARGET="--enable-graphics \
			      --with-ssl \
			      --without-libevent \
			      --without-bzip2 \
			      --without-bzlib \
			      --without-lzma \
			      --without-svgalib \
			      --with-x \
			      --without-directfb \
			      --without-libtiff"

makeinstall_target() {
  : # nope
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -f $PKG_BUILD/.$TARGET_NAME/links $ADDON_BUILD/$PKG_ADDON_ID/bin/
  $STRIP $ADDON_BUILD/$PKG_ADDON_ID/bin/links
}


