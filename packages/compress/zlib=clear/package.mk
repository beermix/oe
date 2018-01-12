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
PKG_VERSION="1.2.8_jtkv4"
PKG_SHA256="b359ef3796f8daa8fe437886164684445a58c65979920127e9df94cb821ed2f0"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.zlib.net"
PKG_URL="https://github.com/jtkukunas/zlib/archive/v1.2.8_jtkv4.tar.gz"
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

  export CFLAGS="$CFLAGS -O3 -march=haswell -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition "
  export CXXFLAGS="$CXXFLAGS -O3 -march=haswell -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition "
  export CFLAGS_GENERATE="$CFLAGS -fprofile-generate -fprofile-dir=pgo "
  export CXXFLAGS_GENERATE="$CXXFLAGS -fprofile-generate -fprofile-dir=pgo "
  export CFLAGS_USE="$CFLAGS -fprofile-use -fprofile-dir=pgo -fprofile-correction "
  export CXXFLAGS_USE="$CXXFLAGS -fprofile-use -fprofile-dir=pgo -fprofile-correction "

  CC="$HOST_CC" CFLAGS="${CFLAGS_USE}" CXXFLAGS="${CXXFLAGS_USE}" mandir=$TOOLCHAIN/share/man includedir=$TOOLCHAIN/include pkgconfigdir=$TOOLCHAIN/lib/pkgconfig ./configure --prefix=/usr --libdir=$TOOLCHAIN/lib --static --shared
}

pre_configure_target() {
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -a $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME/
}

configure_target() {
  cd $PKG_BUILD/.$TARGET_NAME

  export CFLAGS="$CFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition "
  export CXXFLAGS="$CXXFLAGS -O3 -falign-functions=32 -ffat-lto-objects -flto -fno-semantic-interposition "
  export CFLAGS_GENERATE="$CFLAGS -fprofile-generate -fprofile-dir=pgo "
  export CXXFLAGS_GENERATE="$CXXFLAGS -fprofile-generate -fprofile-dir=pgo "
  export CFLAGS_USE="$CFLAGS -fprofile-use -fprofile-dir=pgo -fprofile-correction "
  export CXXFLAGS_USE="$CXXFLAGS -fprofile-use -fprofile-dir=pgo -fprofile-correction "

  CC="$CC" CFLAGS="${CFLAGS_USE}" CXXFLAGS="${CXXFLAGS_USE}" ./configure -prefix=/usr --static --shared
}
