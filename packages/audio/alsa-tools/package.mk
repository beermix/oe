# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="alsa-tools"
PKG_VERSION="1.1.7"
PKG_SITE="ftp://ftp.alsa-project.org/pub/tools/"
PKG_URL="ftp://ftp.alsa-project.org/pub/tools/alsa-tools-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain alsa-lib ncurses gtk+"
PKG_SECTION="audio"
PKG_SHORTDESC="alsa-utils: Advanced Linux Sound Architecture utilities"
PKG_LONGDESC="This package includes the utilities for ALSA, like alsamixer, aplay, arecord, alsactl, iecset and speaker-test."

make_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
  make \
  	CXX="$CXX" \
  	CC="$CC" \
  	CXXFLAGS="$TARGET_CXXFLAGS" \
  	CPPFLAGS="$CPPFLAGS" \
  	RANLIB="$RANLIB" \
  	AR="$AR" 
}



