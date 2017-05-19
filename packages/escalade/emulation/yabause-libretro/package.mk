################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2009-2016 Lukas Rusak (lrusak@libreelec.tv)
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

PKG_NAME="yabause-libretro"
PKG_VERSION="c8f4c57"
PKG_SITE="https://github.com/libretro/yabause"
PKG_GIT_URL="https://github.com/libretro/yabause"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of Yabause to libretro."
PKG_LONGDESC="Port of Yabause to libretro."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_build_target() {
  export GIT_VERSION=$PKG_VERSION
}

make_target() {
  make -C libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp libretro/yabause_libretro.so $INSTALL/usr/lib/libretro/
}
