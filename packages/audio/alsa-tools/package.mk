################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="alsa-tools"
PKG_VERSION="1.1.3"
PKG_SITE="http://www.alsa-project.org/"
PKG_URL="ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain alsa-lib netbsd-curses gtk+"
PKG_SECTION="audio"
PKG_SHORTDESC="alsa-utils: Advanced Linux Sound Architecture utilities"
PKG_LONGDESC="This package includes the utilities for ALSA, like alsamixer, aplay, arecord, alsactl, iecset and speaker-test."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


make_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  make \
  	CXX="$CXX" \
  	CC="$CC" \
  	CXXFLAGS="$TARGET_CXXFLAGS" \
  	CPPFLAGS="$CPPFLAGS" \
  	RANLIB="$RANLIB" \
  	AR="$AR" 
}



