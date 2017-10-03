################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="boost"
PKG_VERSION="1_63_0"
PKG_URL="https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.tar.gz"
#PKG_VERSION="1_63_0"
#PKG_URL="$SOURCEFORGE_SRC/boost/boost/1.63.0/${PKG_NAME}_${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain boost:host Python zlib bzip2"
PKG_LONGDESC="boost: Peer-reviewed STL style libraries for C++"
PKG_AUTORECONF="no"

make_host() {
  cd tools/build/src/engine
    sh build.sh
}

makeinstall_host() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
    cp bin.*/bjam $ROOT/$TOOLCHAIN/bin
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/python2.7 -fPIC"
  export CXXFLAGS="$CXXFLAGS -I$SYSROOT_PREFIX/usr/include/python2.7 -fPIC"
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=$ROOT/$TOOLCHAIN/bin/bjam \
                  --with-python=$ROOT/$TOOLCHAIN/bin/python \
                  --with-python-root=$SYSROOT_PREFIX/usr

  echo "using gcc : `$CC -v 2>&1  | tail -n 1 |awk '{print $3}'` : $CC  : <compileflags>\"$CFLAGS\" <linkflags>\"$LDFLAGS\" ;" \
    > tools/build/src/user-config.jam
}

make_target() {
  :
}

makeinstall_target() {
  $ROOT/$TOOLCHAIN/bin/bjam -d2 variant=release threading=multi debug-symbols=off --ignore-site-config \
                          --layout=system \
                          --prefix=$SYSROOT_PREFIX/usr \
                          --toolset=gcc link=static \
                          --with-chrono \
                          --with-date_time \
                          --with-filesystem \
                          --with-iostreams \
                          --with-python \
                          --with-random \
                          --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                          --with-serialization \
                          --with-system \
                          --with-thread \
                          install
}
