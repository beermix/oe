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

PKG_NAME="xfsprogs"
PKG_VERSION="v4.11.0"
PKG_SITE="https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git"
PKG_GIT_URL="git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git"
PKG_DEPENDS_TARGET="toolchain util-linux libedit"
PKG_DEPENDS_INIT="xfsprogs"
PKG_SECTION="tools"
PKG_SHORTDESC="xfsprogs: Utilities for use with the xfs filesystem"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr \
			      --exec-prefix=/ \
			      --enable-shared=no \
			      --with-gnu-ld \
			      --enable-editline=yes \
			      --enable-lib64=no \
			      --enable-gettext=no"

pre_configure_target() {
  make configure
}

configure_init() {
  : # reuse target
}

make_init() {
  : # reuse target
}

makeinstall_init() {
  mkdir -p $INSTALL/sbin
  cp ../.install_pkg/usr/sbin/xfs_repair $INSTALL/sbin
  cp ../.install_pkg/usr/sbin/fsck.xfs $INSTALL/sbin
  cp ../.install_pkg/usr/sbin/mkfs.xfs $INSTALL/sbin
}