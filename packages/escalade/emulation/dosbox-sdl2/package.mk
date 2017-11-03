################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
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

PKG_NAME="dosbox-sdl2"
PKG_VERSION="1427002"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/duganchen/dosbox"
PKG_URL="https://github.com/duganchen/dosbox/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="dosbox-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain alsa-lib SDL2 SDL2_net SDL_sound fluidsynth libpng munt"
PKG_SECTION="emulation"
PKG_SHORTDESC="DOSBox emulator SDL2 fork by duganchen"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

if [ "$PROJECT" = "Generic" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET glew"
fi

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			   --enable-core-inline \
                           --enable-dynrec \
			   --enable-unaligned_memory \
                           --with-sdl-prefix=$SYSROOT_PREFIX/usr"

pre_configure_target () {
  cd ..
  rm -rf .$TARGET_NAME
}

pre_make_target() {
  if [[ "$PROJECT" =~ "RPi" ]]; then
    sed -i s/C_TARGETCPU.*/C_TARGETCPU\ ARMV7LE/g config.h
  fi
  sed -i s/SVN/SDL2/g config.h
}

post_makeinstall_target() {
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin/
  mkdir -p $INSTALL/usr/config/dosbox
  cp $PKG_DIR/config/dosbox-SDL2.conf $INSTALL/usr/config/dosbox/
  mkdir -p $INSTALL/usr/config/dosbox/shaders
  wget -q https://github.com/duganchen/dosbox_shaders/archive/master.zip
  unzip -j master.zip -d $INSTALL/usr/config/dosbox/shaders
}
