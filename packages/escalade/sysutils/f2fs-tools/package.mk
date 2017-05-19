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
PKG_NAME="f2fs-tools"
PKG_VERSION="v1.8.0"
PKG_SITE="http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git"
PKG_GIT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"
PKG_DEPENDS_TARGET="toolchain util-linux"
PKG_DEPENDS_INIT="f2fs-tools"
PKG_SECTION="tools"
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CONCURRENCY_MAKE_LEVEL=1

PKG_CONFIGURE_OPTS_TARGET="cross_compiling=maybe \
                           --prefix=/usr \
                           --bindir=/bin \
                           --sbindir=/sbin \
                           --host=$TARGET_HOST \
                           --build=$HOST_NAME \
                           --disable-shared \
                           --without-selinux \
                           --with-gnu-ld"

configure_init() {
  : # reuse target
}

make_init() {
  : # reuse target
}

makeinstall_init() {
  mkdir -p $INSTALL/sbin
  mkdir -p $INSTALL/lib
  cp ../.install_pkg/sbin/fsck.f2fs $INSTALL/sbin
  cp ../.install_pkg/sbin/mkfs.f2fs $INSTALL/sbin
  #cp -a $(get_pkg_build libselinux)/.install_pkg/usr/lib/libselinux* $INSTALL/lib
  cp $(get_pkg_build glibc)/.install_pkg/lib/libdl.so.2 $INSTALL/lib
}
