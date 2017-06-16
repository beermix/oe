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

PKG_NAME="b43-fwcutter"
PKG_VERSION="019"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://wireless.kernel.org/en/users/Drivers/b43"
PKG_URL="http://bues.ch/b43/fwcutter/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_SECTION="firmware"
PKG_SHORTDESC="firmware extractor for the b43 kernel module"
PKG_LONGDESC="firmware extractor for the b43 kernel module"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp b43-fwcutter $ROOT/$TOOLCHAIN/bin/b43-fwcutter
}
