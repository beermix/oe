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

PKG_NAME="remake"
PKG_VERSION="085f330"
PKG_URL="https://github.com/rocky/remake/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="autotools:host readline:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="make: GNU make utility to maintain groups of programs"
PKG_LONGDESC="Patched GNU Make 4.1 sources to add improved error reporting, tracing, target listing, graph visualization, and profiling. It also contains debugger. See the remake-3-82 branch for a patched GNU Make 3.82."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="ac_cv_func_gettimeofday=yes \
			    --enable-silent-rules \
			    --without-libintl-prefix \
			    --without-libiconv-prefix"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
			 
			 
post_makeinstall_host() {
  ln -sf remake $TOOLCHAIN/bin/gmake
  ln -sf remake $TOOLCHAIN/bin/make
}
