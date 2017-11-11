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

PKG_NAME="zlib"
PKG_VERSION="e07a52d"
PKG_SHA256="c762c24d24d3ead93a21a0d540c49751b45058dbe5b00f71f48526b335e85b37"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/Dead2/zlib-ng"
PKG_URL="https://github.com/Dead2/zlib-ng/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="zlib-ng-$PKG_VERSION*"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET=""
PKG_SECTION="compress"
PKG_SHORTDESC="zlib: A general purpose (ZIP) data compression library"
PKG_LONGDESC="zlib is a general purpose data compression library. All the code is thread safe. The data format used by the zlib library is described by RFCs (Request for Comments) 1950 to 1952 in the files ftp://ds.internic.net/rfc/rfc1950.txt (zlib format), rfc1951.txt (deflate format) and rfc1952.txt (gzip format)."
PKG_AUTORECONF="no"
PKG_USE_NINJA="no"

export CCACHE_DISABLE=1
PKG_CMAKE_OPTS_TARGET="-DZLIB_COMPAT=ON"
PKG_CMAKE_OPTS_HOST="-DZLIB_COMPAT=ON"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -r -i $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  ./configure --prefix=/usr --libdir=$TOOLCHAIN/lib --zlib-compat
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -r -i $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  ./configure --prefix=/usr --zlib-compat
}
