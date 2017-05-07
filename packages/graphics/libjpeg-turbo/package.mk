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

PKG_NAME="libjpeg-turbo"
PKG_VERSION="2a4f189"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libjpeg-turbo/libjpeg-turbo"
PKG_GIT_URL="https://github.com/libjpeg-turbo/libjpeg-turbo"
PKG_DEPENDS_TARGET="toolchain libjpeg-turbo:host"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="libjpeg-turbo: a high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD instructions (MMX, SSE2, etc.) to accelerate baseline JPEG compression and decompression."
PKG_LONGDESC="libjpeg-turbo is a high-speed version of libjpeg for x86 and x86-64 processors which uses SIMD instructions (MMX, SSE2, etc.) to accelerate baseline JPEG compression and decompression. libjpeg-turbo is generally 2-4x as fast as the unmodified version of libjpeg, all else being equal."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="yes"

pre_build_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
}

PKG_CONFIGURE_OPTS_HOST="--enable-static \
                         --disable-shared \
                         --with-jpeg8 \
                         --without-simd \
                         --with-pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --with-jpeg8 --with-pic"

if [ "$SIMD_SUPPORT" = "no" ]; then
  PKG_CONFIGURE_OPTS_TARGET+=" --without-simd"
fi

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
