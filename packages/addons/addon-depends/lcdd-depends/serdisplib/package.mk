################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017 Team LibreELEC
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="serdisplib"
PKG_VERSION="1.97.9"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://serdisplib.sourceforge.net/"
PKG_URL="$SOURCEFORGE_SRC/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libusb-compat"
PKG_SHORTDESC="serdisplib: a lcd control library"
PKG_LONGDESC="Library to drive serial/parallel/usb displays with built-in controllers"


PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--prefix=$SYSROOT_PREFIX/usr \
                           --bindir=$SYSROOT_PREFIX/usr/bin \
                           --enable-libusb \
                           --disable-libSDL \
                           --with-drivers=all"

pre_configure_target() {
  # serdisplib fails to build in subdirs
  cd $PKG_BUILD
    rmdir .$TARGET_NAME

  # use libusb-config from sysroot
  export ac_cv_path_LIBUSB_CONFIG=$SYSROOT_PREFIX/usr/bin/libusb-config
}

post_make_target() {
  # copy necessary libs and headers to build serdisplib support
  # into the driver glcd from lcdproc
  mkdir -p $SYSROOT_PREFIX/usr/include/serdisplib
  cp include/serdisplib/*.h $SYSROOT_PREFIX/usr/include/serdisplib
  mkdir -p $SYSROOT_PREFIX/usr/lib
  cp lib/libserdisp.so* $SYSROOT_PREFIX/usr/lib
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
  cp lib/libserdisp.so* $INSTALL/usr/lib
}
