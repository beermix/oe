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

PKG_NAME="nasm"
PKG_VERSION="2.12.01"
PKG_URL="https://dl.dropboxusercontent.com/s/69l05y4epirp3cr/nasm-2.12.01.tar.xz"
PKG_VERSION="2.13.01"
PKG_URL="https://fossies.org/linux/misc/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST=""
PKG_SECTION="lang"
PKG_SHORTDESC="nasm: A 80x86 assembler which can create a wide rande of object formats"
PKG_LONGDESC="The Netwide Assembler, NASM, is an 80x86 assembler designed for portability and modularity. It supports a range of object file formats, including Linux, Microsoft 16-bit OBJ and Win32. It will also output plain binary files. Its syntax is designed to be sim- ple and easy to understand, similar to Intel's but less complex. It supports Pentium, P6 and MMX opcodes, and has macro capability. It includes a disassembler as well."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_CONFIGURE_OPTS_HOST="--enable-lto --enable-ccache=no"

#post_make_target() {
#  mkdir -p $INSTALL_DEV/usr/bin/
#}