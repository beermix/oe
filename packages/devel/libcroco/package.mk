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

PKG_NAME="libcroco"
PKG_VERSION="0.6.12"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://eigen.tuxfamily.org/index.php?title=Main_Page"
PKG_URL="http://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/libcroco-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="libxml2:host pkg-config:host"
PKG_SECTION="devel"
PKG_BUILD_FLAGS="+pic:host"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"