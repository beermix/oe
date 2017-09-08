################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2017 Stephan Raue (stephan@openelec.tv)
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
PKG_VERSION="1_63_0"
PKG_URL="https://dl.bintray.com/boostorg/release/1.63.0/source/boost_1_63_0.tar.gz"
#PKG_VERSION="1_63_0"
#PKG_URL="$SOURCEFORGE_SRC/boost/boost/1.63.0/${PKG_NAME}_${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_HOST=""
PKG_DEPENDS_TARGET="toolchain boost:host Python zlib bzip2"
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
  mkdir -p $ROOT/$TOOLCHAIN/bin
    cp bin.*/bjam $ROOT/$TOOLCHAIN/bin
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
  #export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|"`
  #export CXXLAGS=`echo $CXXLAGS | sed -e "s|-O.|-O3|"`
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=$ROOT/$TOOLCHAIN/bin/bjam \
                  --with-python=$ROOT/$TOOLCHAIN/bin/python \
                  --with-python-root=$SYSROOT_PREFIX/usr \

  echo "using gcc : `$CC -v 2>&1  | tail -n 1 |awk '{print $3}'` : $CC  : <compileflags>\"$CFLAGS\" <linkflags>\"$LDFLAGS\" ;" \
    > tools/build/src/user-config.jam
}

make_target() {
  : # nothing todo, we use makeinstall_target()
}

makeinstall_target() {
  $ROOT/$TOOLCHAIN/bin/bjam -d2 --toolset=gcc link=shared target-os=linux variant=release threading=multi debug-symbols=off \
                                --prefix=$SYSROOT_PREFIX/usr \
                                --ignore-site-config \
                                --layout=system \
                                --with-thread \
                                --with-iostreams \
                                --with-system \
                                --with-serialization \
                                --with-filesystem \
                                --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                                --with-chrono \
                                --with-date_time \
                                --with-program_options \
                                --with-random \
                                --with-exception \
                                --with-signals \
                                --with-python -j3 \
                                install
                                
  $ROOT/$TOOLCHAIN/bin/bjam -d2 --toolset=gcc link=shared target-os=linux variant=release threading=multi debug-symbols=off \
                                --prefix=$INSTALL/usr \
                                --ignore-site-config \
                                --layout=system \
                                --with-thread \
                                --with-iostreams \
                                --with-system \
                                --with-serialization \
                                --with-filesystem \
                                --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                                --with-chrono \
                                --with-date_time \
                                --with-program_options \
                                --with-random \
                                --with-exception \
                                --with-signals \
                                --with-python  \
                                install
}