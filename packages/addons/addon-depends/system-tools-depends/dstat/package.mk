################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="dstat"
PKG_VERSION="77e9347"
PKG_SHA256="2b2f4ef3a0d1dc6d0a4bc2f54a57ba6f1e278333881a07df7e55aec502a48c7c"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://dag.wiee.rs/home-made/dstat"
PKG_URL="https://github.com/dagwieers/dstat/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python2"
PKG_SECTION="tools"
PKG_SHORTDESC="Versatile resource statistics tool"
PKG_LONGDESC="Versatile resource statistics tool"
PKG_TOOLCHAIN="manual"

post_unpack() {
rm $PKG_BUILD/Makefile
}
