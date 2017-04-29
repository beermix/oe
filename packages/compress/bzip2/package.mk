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
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="bzip2 data compressor"
PKG_LONGDESC="bzip2 is a freely available, patent free (see below), high-quality data compressor. It typically compresses files to within 10% to 15% of the best available techniques (the PPM family of statistical compressors), whilst being around twice as fast at compression and six times faster at decompression."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_build_host() {
  mkdir -p $ROOT/$PKG_BUILD/.$HOST_NAME
  cp -r $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$HOST_NAME
}

make_host() {
  cd $ROOT/$PKG_BUILD/.$HOST_NAME
  make CC=$HOST_CC CFLAGS="$CFLAGS -fPIC -DPIC" LDFLAGS="-s -Wl,-z,relro"
}

makeinstall_host() {
  make install PREFIX=$ROOT/$TOOLCHAIN
}

pre_build_target() {
  mkdir -p $ROOT/$PKG_BUILD/.$TARGET_NAME
  cp -r $ROOT/$PKG_BUILD/* $ROOT/$PKG_BUILD/.$TARGET_NAME
}

make_target() {
  cd $ROOT/$PKG_BUILD/.$TARGET_NAME
    make -f Makefile libbz2.a bzip2 bzip2recover CC=$CC CFLAGS="$CFLAGS -fPIC -DPIC" 
}

makeinstall_target() {
  make install PREFIX=$SYSROOT_PREFIX/usr
  make install PREFIX=$INSTALL/usr
}
