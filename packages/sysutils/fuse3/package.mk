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

PKG_NAME="fuse3"
PKG_VERSION="3.1.0"
PKG_SITE="https://github.com/libfuse/libfuse/"
PKG_URL="https://dl.dropboxusercontent.com/s/bqrsyjf2eb6oes6/fuse3-3.1.0.tar.xz"
PKG_SOURCE_DIR="fuse-3.0.0"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="fuse: A simple user-space filesystem interface for Linux"
PKG_LONGDESC="FUSE provides a simple interface for userspace programs to export a virtual filesystem to the Linux kernel. FUSE also aims to provide a secure method for non privileged users to create and mount their own filesystem implementations."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="MOUNT_FUSE_PATH=/usr/sbin \
                           --enable-lib \
                           --enable-util \
                           --disable-example \
                           --enable-mtab \
                           --disable-rpath \
                           --with-gnu-ld"

post_makeinstall_target() {
  rm -rf $INSTALL/etc/init.d
  rm -rf $INSTALL/etc/udev
}
