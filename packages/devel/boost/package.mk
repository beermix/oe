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

PKG_NAME="boost"
PKG_VERSION="1_65_1"
PKG_URL="https://fossies.org/linux/misc/boost_1_65_1.tar.xz"
#PKG_URL="https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz"
#PKG_VERSION="1_63_0"
#PKG_URL="$SOURCEFORGE_SRC/boost/boost/1.63.0/${PKG_NAME}_${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain boost:host Python2:host zlib bzip2"
PKG_SECTION="devel"
PKG_SHORTDESC="boost: Peer-reviewed STL style libraries for C++"
PKG_LONGDESC="Boost provides free peer-reviewed portable C++ source libraries. The emphasis is on libraries which work well with the C++ Standard Library. One goal is to establish existing practice and provide reference implementations so that the Boost libraries are suitable for eventual standardization. Some of the libraries have already been proposed for inclusion in the C++ Standards Committee's upcoming C++ Standard Library Technical Report."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_host() {
  cd tools/build/src/engine
    sh build.sh
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp bin.*/bjam $TOOLCHAIN/bin
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/python2.7 -fPIC"
  export CXXFLAGS="$CXXFLAGS -I$SYSROOT_PREFIX/usr/include/python2.7 -fPIC"
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=$TOOLCHAIN/bin/bjam \
                  --with-python=$TOOLCHAIN/bin/python \
                  --with-python-root=$SYSROOT_PREFIX/usr

  echo "using gcc : `$CC -v 2>&1  | tail -n 1 |awk '{print $3}'` : $CC  : <compileflags>\"$CFLAGS\" <linkflags>\"$LDFLAGS\" ;" \
    > tools/build/src/user-config.jam
}

make_target() {
  :
}

makeinstall_target() {
  $TOOLCHAIN/bin/bjam -d2 variant=release threading=multi debug-symbols=off --ignore-site-config \
                          --layout=system \
                          --prefix=$SYSROOT_PREFIX/usr \
                          --toolset=gcc link=static \
                          --with-chrono \
                          --with-date_time \
                          --with-filesystem \
                          --with-iostreams \
                          --with-python \
                          --with-program_options \
                          --with-exception \
                          --with-random \
                          --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                          --with-serialization \
                          --with-system \
                          --with-thread \
                          install
}
