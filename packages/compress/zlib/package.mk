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
PKG_VERSION="1.2.8.dfsg"
PKG_SHA256="180a1e3cff02f5a496e541fb7fafcd97acb8922e97521ee29ef7c5dcb5978d57"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="http://192.168.1.200:8080/%2Fzlib-1.2.8.dfsg.tar.xz"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET=""
PKG_SECTION="compress"
PKG_SHORTDESC="zlib: A general purpose (ZIP) data compression library"
PKG_LONGDESC="zlib is a general purpose data compression library. All the code is thread safe. The data format used by the zlib library is described by RFCs (Request for Comments) 1950 to 1952 in the files ftp://ds.internic.net/rfc/rfc1950.txt (zlib format), rfc1951.txt (deflate format) and rfc1952.txt (gzip format)."
PKG_TOOLCHAIN="make"

pre_configure_host() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME/
}

configure_host() {
  cd $PKG_BUILD/.$HOST_NAME
  
  CC="$HOST_CC" \
  CFLAGS="$HOST_CFLAGS -O3 -pipe -Wall" \
  LDFLAGS="$HOST_LDFLAGS" \
  mandir=$TOOLCHAIN/share/man includedir=$TOOLCHAIN/include pkgconfigdir=$TOOLCHAIN/lib/pkgconfig \
  ./configure --prefix=/usr --libdir=$TOOLCHAIN/lib
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  
  CC="$CC" \
  CFLAGS="$CFLAGS -O3 -Wall" \
  LDFLAGS="$LDFLAGS" \
  ./configure -prefix=/usr
}
