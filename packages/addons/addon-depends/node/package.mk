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

PKG_NAME="node"
PKG_VERSION="9.3.0"
PKG_SHA256="e066d0223d4cfde30f8fa8c537c9b38291f69772fcf8e5833c95b9722cb7871e"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://nodejs.org"
PKG_URL="https://github.com/nodejs/node/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_SHORTDESC="Node.js JavaScript runtime"
PKG_LONGDESC="Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. The Node.js package ecosystem, npm, is the largest ecosystem of open source libraries in the world."

HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN --no-cross-compiling --partly-static --without-npm --without-perfctr --without-ssl"

pre_configure_host() {
  cd ..
  LDFLAGS="-s"
  unset CFLAGS
}
