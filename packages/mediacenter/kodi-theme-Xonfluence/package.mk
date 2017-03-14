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

PKG_NAME="kodi-theme-Xonfluence"
PKG_VERSION="8384f46"
PKG_GIT_URL="https://github.com/Helly1206/skin.xonfluence"
PKG_GIT_BRANCH="jarvis"
PKG_DEPENDS_TARGET="toolchain kodi:host"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="kodi-theme-xonfluence: Kodi Mediacenter default theme"
PKG_LONGDESC="Kodi Media Center (which was formerly named Xbox Media Center and XBMC) is a free and open source cross-platform media player and home entertainment system software with a 10-foot user interface designed for the living-room TV. Its graphical user interface allows the user to easily manage video, photos, podcasts, and music from a computer, optical disk, local network, and the internet using a remote control."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  TexturePacker -input media/ \
                -output Textures.xbt \
                -dupecheck \
                -use_none
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/kodi/addons/skin.xonfluence
    cp -R */ $INSTALL/usr/share/kodi/addons/skin.xonfluence
    cp *.txt $INSTALL/usr/share/kodi/addons/skin.xonfluence
    cp *.xml $INSTALL/usr/share/kodi/addons/skin.xonfluence
    cp *.png $INSTALL/usr/share/kodi/addons/skin.xonfluence
      rm -rf $INSTALL/usr/share/kodi/addons/skin.xonfluence/media

  mkdir -p $INSTALL/usr/share/kodi/addons/skin.xonfluence/media
    cp Textures.xbt $INSTALL/usr/share/kodi/addons/skin.xonfluence/media

# Rebrand
  #sed -e "s,@DISTRONAME@,OpenELEC,g" -i $INSTALL/usr/share/kodi/addons/skin.xonfluence/720p/IncludesHomeMenuItems.xml
}
