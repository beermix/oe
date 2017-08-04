################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
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

PKG_NAME="netbsd-curses"
PKG_VERSION="0.2.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_SITE="https://github.com/sabotage-linux/netbsd-curses"
PKG_URL="http://ftp.barfooze.de/pub/sabotage/tarballs/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="netbsd-curses: netbsd-libcurses portable edition"
PKG_LONGDESC="netbsd-curses: netbsd-libcurses portable edition"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make HOSTCC="$HOST_CC" CFLAGS="$CFLAGS" PREFIX=/usr all-dynamic
}

makeinstall_target() {
  make PREFIX=$SYSROOT_PREFIX/usr install-dynamic
  make PREFIX=$INSTALL/usr install-dynamic
}
