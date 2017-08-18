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

PKG_NAME="atkmm"
PKG_VERSION="2.25.3"
PKG_SITE="http://www.X.org"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/atkmm/2.25/atkmm-2.25.3.tar.xz"
PKG_DEPENDS_TARGET="toolchain util-macros atk glibmm"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="xtrans: Abstract network code for X"
PKG_LONGDESC="Abstract network code for X."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
