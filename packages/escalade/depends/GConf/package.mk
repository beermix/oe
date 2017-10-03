################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="GConf"
PKG_VERSION="3.2.6"
PKG_SITE="http://eigen.tuxfamily.org/index.php?title=Main_Page"
PKG_URL="ftp://ftp.gnome.org/pub/GNOME/sources/GConf/3.2/GConf-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib glib"
PKG_SECTION="depends"
PKG_SHORTDESC="gconf"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--disable-orbit --disable-static"
