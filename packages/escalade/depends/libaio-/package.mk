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

PKG_NAME="libaio"
PKG_VERSION="0.3.110"
PKG_SITE="http://http://lse.sourceforge.net/io/aio.html"
PKG_URL="https://dl.dropboxusercontent.com/s/p78byieq4wr2izd/libaio-0.3.110.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="depends"
PKG_SHORTDESC="Kernel Asynchronous I/O (AIO) Support for Linux"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_build_target() {
  strip_lto
}
