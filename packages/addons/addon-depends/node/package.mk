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
PKG_VERSION="8.9.3"
PKG_SHA256="a5042d983f9815ee18a5c6fd75f8b3b2022ed96a2aaa8834300cd1ee81e8870c"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://nodejs.org"
PKG_URL="https://github.com/nodejs/node/archive/v$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain libuv:host"
PKG_DEPENDS_TARGET="toolchain zlib openssl libuv"
PKG_SHORTDESC="Node.js JavaScript runtime"
PKG_LONGDESC="Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. The Node.js package ecosystem, npm, is the largest ecosystem of open source libraries in the world."

HOST_CONFIGURE_OPTS="--prefix=$TOOLCHAIN --with-intl=none --without-npm --without-ssl --ninja"
                     
TARGET_CONFIGURE_OPTS="--prefix=/usr --shared-zlib --shared-openssl --with-intl=none --ninja"

pre_configure_host() {
  unset CPPFLAGS
  unset CFLAGS
  unset CXXFLAGS
  cd ..
}

#pre_configure_target() {
#  LDFLAGS="$LDFLAGS -lz -lssl -lstdc++ -lm -luv -lrt -lpthread -lnsl -ldl"
#  cd ..
#}

make_target() {
  cd $PKG_BUILD/out/Release
  ninja -j${CONCURRENCY_MAKE_LEVEL}
}

makeinstall_target() {
  mkdir -p $INSTALL/bin/
  cp $PKG_BUILD/out/Release/node $INSTALL/bin/
}

make_host() {
  cd $PKG_BUILD/out/Release
  ninja -j${CONCURRENCY_MAKE_LEVEL}
}

makeinstall_host() {
  mkdir -p $INSTALL/bin/
  cp $PKG_BUILD/out/Release/node $TOOLCHAIN/bin/
}