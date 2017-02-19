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

PKG_NAME="bzip2"
PKG_VERSION="1.0.6"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.bzip.org"
PKG_URL="http://www.bzip.org/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="bzip2 data compressor"
PKG_LONGDESC="bzip2 is a freely available, patent free (see below), high-quality data compressor. It typically compresses files to within 10% to 15% of the best available techniques (the PPM family of statistical compressors), whilst being around twice as fast at compression and six times faster at decompression."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

MAKEFLAGS=-j1

pre_build_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -r $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME
}

make_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  make -f Makefile-libbz2_so CC=$HOST_CC CFLAGS="$CFLAGS -fPIC -DPIC" LDFLAGS="$LDFLAGS" AR="$AR"
}

makeinstall_host() {
  make install PREFIX=$ROOT/$TOOLCHAIN
}

pre_build_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -r $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME
}

make_target() {
  make bzip2 bzip2recover libbz2.a CC=$CC CFLAGS="$CFLAGS -fPIC -DPIC" LDFLAGS="$LDFLAGS" AR="$AR"
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp bzlib.h $SYSROOT_PREFIX/usr/include
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -P libbz2.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/bin
    cp -P bzip2 $INSTALL/usr/bin
     cp -P bzip2recover $INSTALL/usr/bin
}
