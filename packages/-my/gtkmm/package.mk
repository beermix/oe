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

PKG_NAME="gtkmm"
PKG_VERSION="3.22.0"
PKG_REV="2"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_URL="https://download.gnome.org/sources/gtkmm/3.22/gtkmm-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain libxml2 sqlite"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="aria2: lightweight multi-protocol & multi-source command-line download utility"
PKG_LONGDESC="aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink. aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces"
PKG_AUTORECONF="no"

pre_configure_target() {
  cd $ROOT/$PKG_BUILD
  rm -rf .$TARGET_NAME
  
}
PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr --disable-documentation"
