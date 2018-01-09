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
PKG_VERSION="8.9.4"
PKG_SHA256="7dd570b083f75cf2332c42446a01ec140409fa1df46f7af806e0775bdddf6852"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://nodejs.org"
PKG_URL="https://github.com/nodejs/node/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_SHORTDESC="Node.js JavaScript runtime"
PKG_LONGDESC="Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. The Node.js package ecosystem, npm, is the largest ecosystem of open source libraries in the world."

HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN \
                     --fully-static \
                     --with-intl=none \
                     --without-npm \
                     --without-ssl"

pre_configure_host() {
  cd ..
#  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.||"`
#  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.||"`
#  export LDFLAGS=`$LDFLAGS -s"`
}
