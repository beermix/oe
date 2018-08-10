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

PKG_NAME="make"
PKG_VERSION="4.2.1"
PKG_SHA256="d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://www.gnu.org/software/make/"
PKG_URL="http://ftpmirror.gnu.org/make/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_HOST=""
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="make: GNU make utility to maintain groups of programs"
PKG_LONGDESC="The 'make' utility automatically determines which pieces of a large program need to be recompiled, and issues commands to recompile them. This is GNU 'make', which was implemented by Richard Stallman and Roland McGrath. GNU 'make' conforms to section 6.2 of EEE Standard 1003.2-1992' (POSIX.2)."
PKG_TOOLCHAIN="manual"

export CC=$LOCAL_CC
export CXX=$LOCAL_CXX

export CFLAGS="-march=haswell -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2"
export CXXFLAGS="-march=haswell -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2"
LDFLAGS="-Wl,-O1,--as-needed,-z,relro,-z,now -s"

PKG_CONFIGURE_OPTS_HOST="--without-guile"

post_makeinstall_host() {
#  ln -sf make $TOOLCHAIN/bin/gmake
 mkdir  -p $TOOLCHAIN/bin/
 ln -sf /usr/bin/make $TOOLCHAIN/bin/gmake
 ln -sf /usr/bin/make $TOOLCHAIN/bin/make

#  mkdir -p $TOOLCHAIN/share/aclocal

#  cp -r $PKG_DIR/src/bin/* $TOOLCHAIN/bin/
#  cp -r -i $PKG_DIR/src/m4/* $TOOLCHAIN/share/aclocal/
  
#  mkdir -p $TOOLCHAIN/share/include
#  cp -r -i $PKG_DIR/include/* $TOOLCHAIN/share/include
}
