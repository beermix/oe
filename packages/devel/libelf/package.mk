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

PKG_NAME="libelf"
PKG_VERSION="0.8.13"
PKG_SITE="http://www.mr511.de/software/"
PKG_URL="http://www.mr511.de/software/libelf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="intltool:host libtool:host bison:host flex:host"
PKG_DEPENDS_TARGET="libelf:host"
PKG_SECTION="devel"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--enable-compat --enable-elf64 --enable-extended-format --enable-static --disable-shared"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

makeinstall_target() {
  mkdir -p $INSTALL_DEV/bin
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp lib/elf_repl.h $SYSROOT_PREFIX/usr/include
    cp lib/gelf.h $SYSROOT_PREFIX/usr/include
    cp lib/libelf.h $SYSROOT_PREFIX/usr/include
    cp lib/nlist.h $SYSROOT_PREFIX/usr/include
    cp lib/sys_elf.h $SYSROOT_PREFIX/usr/include
    
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp lib/libelf.a $SYSROOT_PREFIX/usr/lib
}