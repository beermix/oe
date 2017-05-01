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

PKG_NAME="mediacenter"
PKG_VERSION=""
PKG_SITE="http://www.openelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain $MEDIACENTER"
PKG_PRIORITY="optional"
PKG_SECTION="virtual"
PKG_SHORTDESC="Mediacenter: Metapackage"
PKG_LONGDESC=""

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$MEDIACENTER" = "kodi" ]; then
# some python stuff needed for various addons
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET Pillow"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET simplejson"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pycryptodome"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET xmlstarlet"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET peripheral.joystick"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.iptvsimple"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pvr.iptvsimple.multi"

# kodi-binary-addons inputstream
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET inputstream.rtmp"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET inputstream.adaptive"

# audioencoder
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.flac"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.lame"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.vorbis"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET audioencoder.wav"

# other packages
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET kodi-theme-AeonNox"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET OpenELEC-settings"

  if [ -n "$SKINS" ]; then
    for i in $SKINS; do
      PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $MEDIACENTER-theme-$i"
    done
  fi

fi
