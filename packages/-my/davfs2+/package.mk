################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="davfs2"
PKG_VERSION="1.5.2"
PKG_SITE="https://shadowvpn.org/"
PKG_URL="http://download.savannah.gnu.org/releases/davfs2/davfs2-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain neon"

PKG_SECTION="torrenter"

PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-lib \
                           --enable-util \
                           --disable-example \
                           --enable-mtab \
                           --disable-rpath \
                           --with-gnu-ld"

pre_configure_target() {
# fuse fails to build with GOLD linker on gcc-4.9
  strip_gold
}

post_makeinstall_target() {
  rm -rf $INSTALL/etc/init.d
  rm -rf $INSTALL/etc/udev
}
