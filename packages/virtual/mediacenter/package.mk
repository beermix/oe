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

_add_binary_addon() {
  [ -f $ROOT/$PACKAGES/mediacenter/kodi-binary-addons/$1/package.mk ] && PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $1" || true
}

if [ "$MEDIACENTER" = "kodi" ]; then
# some python stuff needed for various addons
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET Pillow"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET simplejson"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pycrypto"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET xmlstarlet"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET peripheral.joystick"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET visualization.shadertoy pvr.iptvsimple.multi inputstream.adaptive inputstream.mpd inputstream.rtmp inputstream.smoothstream"
  #PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET peripheral.joystick pvr.iptvsimple.multi inputstream.adaptive inputstream.mpd inputstream.rtmp inputstream.smoothstream visualization.waveform visualization.wavforhue screensaver.stars screensaver.asteroids visualization.fishbmc visualization.goom visualization.projectm visualization.spectrum  visualization.waveform visualization.wavforhue adsp.basic audiodecoder.modplug audiodecoder.sidplay audioencoder.wav audioencoder.flac audioencoder.lame audioencoder.vorbis"

# other packages
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET OpenELEC-settings"

  if [ -n "$SKINS" ]; then
    for i in $SKINS; do
      PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $MEDIACENTER-theme-$i"
    done
  fi

fi
