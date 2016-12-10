################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
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

PKG_NAME="libselinux"
PKG_VERSION="libselinux-2.5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_GIT_URL="https://github.com/SELinuxProject/selinux"
PKG_DEPENDS_TARGET="toolchain pcre"
PKG_SECTION="tools"
PKG_SHORTDESC="Security Enhanced Linux (SELinux) userland libraries."
PKG_IS_ADDON="no"

PKG_AUTORECONF="no"

pre_build_target() {
  strip_lto
  export CFLAGS=`echo $CFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export CPPFLAGS=`echo $CPPFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-fstack-protector-strong||g"`
  export LDFLAGS=`echo $LDFLAGS | sed -e "s|-D_FORTIFY_SOURCE=.||g"`
}


make_target() {
  make install DESTDIR=$SYSROOT_PREFIX
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
  cp -a lib*/src/*.so* $INSTALL/usr/lib
}
