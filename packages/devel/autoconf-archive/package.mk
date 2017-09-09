################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="autoconf-archive"
PKG_VERSION="37a75750d646bf578c281ca1be18e8a29bb7cc73"
PKG_SITE="http://ftp.gnu.org/gnu/autoconf-archive"
PKG_GIT_URL="git://git.savannah.gnu.org/autoconf-archive.git"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="autoconf-archive: macros for autoconf"
PKG_LONGDESC="autoconf-archive is an package of m4 macros"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"




PKG_CONFIGURE_OPTS_HOST="--target=$TARGET_NAME --prefix=$ROOT/$TOOLCHAIN"

makeinstall_host() {
# make install
  make prefix=$SYSROOT_PREFIX/usr install

# remove problematic m4 file
  rm -rf $SYSROOT_PREFIX/usr/share/aclocal/ax_prog_cc_for_build.m4
}
