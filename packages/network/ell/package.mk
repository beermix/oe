################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
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

PKG_NAME="ell"
PKG_VERSION="726ca36"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://git.kernel.org/cgit/libs/ell/ell.git/about"
PKG_URL="https://git.kernel.org/pub/scm/libs/ell/ell.git/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="network"
PKG_SHORTDESC="Embedded Linux library"
PKG_LONGDESC="Embedded Linux library"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  cd $PKG_BUILD
  ./bootstrap-configure --host=$TARGET_NAME --build=$HOST_NAME --prefix=/usr 
}

