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

PKG_NAME="make-dfsg"
PKG_VERSION="e4f294d"
PKG_GIT_URL="git://anonscm.debian.org/git/users/srivasta/debian/make-dfsg.git"
PKG_DEPENDS_HOST="autotools:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="make: GNU make utility to maintain groups of programs"
PKG_LONGDESC="The 'make' utility automatically determines which pieces of a large program need to be recompiled, and issues commands to recompile them. This is GNU 'make', which was implemented by Richard Stallman and Roland McGrath. GNU 'make' conforms to section 6.2 of EEE Standard 1003.2-1992' (POSIX.2)."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--disable-load --without-guile"
			 
PKG_CONFIGURE_OPTS_TARGET="-C $PKG_CONFIGURE_OPTS_HOST"
			 
post_makeinstall_host() {
  ln -sf make $TOOLCHAIN/bin/gmake

}
