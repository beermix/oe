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
PKG_SITE="http://www.mpfr.org/"
PKG_URL="http://www.mr511.de/software/libelf-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="intltool:host libtool:host  bison:hos flex:host"
PKG_SECTION="devel"
PKG_SHORTDESC="mpfr: A C library for multiple-precision floating-point computations with exact roundi"
PKG_LONGDESC="The MPFR library is a C library for multiple-precision floating-point computations with exact rounding (also called correct rounding). It is based on the GMP multiple-precision library. The main goal of MPFR is to provide a library for multiple-precision floating-point computation which is both efficient and has well-defined semantics. It copies the good ideas from the ANSI/IEEE-754 standard for double-precision floating-point arithmetic (53-bit mantissa)."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_HOST="-enable-elf64=yes --disable-sanity-checks --disable-shared --enable-elf64"
			 
PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

post_make_target() {
  mkdir -p $INSTALL_DEV/usr/bin/
}

