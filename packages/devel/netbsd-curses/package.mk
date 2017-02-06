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

PKG_NAME="netbsd-curses"
#PKG_VERSION="0.2.0"
PKG_VERSION="22acb33"
PKG_SITE="https://github.com/sabotage-linux/netbsd-curses"
#PKG_URL="http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-$PKG_VERSION.tar.xz"
PKG_GIT_URL="git://github.com/sabotage-linux/netbsd-curses"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_SECTION="devel"
PKG_SHORTDESC="netbsd-curses: netbsd-libcurses portable edition"
PKG_LONGDESC="netbsd-curses: netbsd-libcurses portable edition"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

  
make_target() {
  make HOSTCC="$HOST_CC" CFLAGS="$CFLAGS" PREFIX=/usr all-static -j1
}

makeinstall_target() {
  make HOSTCC="$HOST_CC" PREFIX=$SYSROOT_PREFIX/usr install-static -j1
}
