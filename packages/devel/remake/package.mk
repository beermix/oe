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
PKG_VERSION="689f5cf"
PKG_REV="1"
PKG_GIT_URL="https://github.com/rocky/remake.git"
PKG_DEPENDS_HOST="autotools:host"
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="make: GNU make utility to maintain groups of programs"
PKG_LONGDESC="Patched GNU Make 4.1 sources to add improved error reporting, tracing, target listing, graph visualization, and profiling. It also contains debugger. See the remake-3-82 branch for a patched GNU Make 3.82."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

CFLAGS="-march=native -O3 -Wall -pipe"
LDFLAGS="-s -Wl,--export-dynamic -Wl,-Bsymbolic-functions -Wl,-z,relro"
  
PKG_CONFIGURE_OPTS_HOST="ac_cv_func_gettimeofday=yes \
			 --without-libiconv-prefix \
			 --without-libintl-prefix \
			 --disable-silent-rules \
			 --with-gnu-ld \
			 --disable-nls"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"
			 
post_makeinstall_host() {
  ln -sf remake $ROOT/$TOOLCHAIN/bin/gmake
  ln -sf remake $ROOT/$TOOLCHAIN/bin/make
}
