################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2015 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="xxd"
PKG_VERSION="1.10"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"

PKG_SECTION="system"
PKG_SHORTDESC="xxd - make a hexdump or do the reverse"
PKG_LONGDESC="xxd - make a hexdump or do the reverse"
PKG_MAINTAINER="vpeter"



make_target() {
  #cp $PKG_DIR/xxd.c $(get_build_dir xxd)
  #$CC xxd.c -o xxd
  $CC $PKG_DIR/xxd.c -o xxd
  $CC $PKG_DIR/rawhid.c -o rawhid
}

makeinstall_target() {
	mkdir -p .install_pkg/usr/bin
	cp xxd .install_pkg/usr/bin
	cp rawhid .install_pkg/usr/bin
}

