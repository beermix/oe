################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="zlib"
PKG_VERSION="1.2.11"
PKG_SHA256="4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="http://zlib.net/$PKG_NAME-$PKG_VERSION.tar.xz"
#PKG_URL="https://github.com/sspring/zlib/archive/${PKG_VERSION}.tar.gz"
#PKG_DEPENDS_HOST="cmake:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="compress"
PKG_SHORTDESC="zlib: A general purpose (ZIP) data compression library"
PKG_LONGDESC="zlib is a general purpose data compression library. All the code is thread safe. The data format used by the zlib library is described by RFCs (Request for Comments) 1950 to 1952 in the files ftp://ds.internic.net/rfc/rfc1950.txt (zlib format), rfc1951.txt (deflate format) and rfc1952.txt (gzip format)."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic:host +pic"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release"

pre_configure_target() {
  export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  export CXXFLAGS=`echo $CXXFLAGS | sed -e "s|-O.|-O3|"`
}

post_configure_target() {
 ## configure minizip
 (
  cd $PKG_BUILD/.$TARGET_NAME/contrib/minizip
  rm Makefile
  export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:../../"
  do_autoreconf
  ./configure --host=$TARGET_NAME --build=$HOST_NAME $TARGET_CONFIGURE_OPTS --enable-static --disable-shared
 )
}

pre_build_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

pre_build_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -RP $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
}

post_make_target() {
 # make minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip
}

post_makeinstall_target() {
 # Install minizip
 make -C $PKG_BUILD/.$TARGET_NAME/contrib/minizip DESTDIR=$SYSROOT_PREFIX install -j1
}
