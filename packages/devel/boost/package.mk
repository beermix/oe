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
PKG_VERSION="1_66_0"
PKG_LICENSE="OSS"
PKG_SITE="http://www.boost.org/"
PKG_URL="https://dl.bintray.com/boostorg/release/1.66.0/source/boost_$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain boost:host Python2 zlib bzip2 xz"
PKG_LONGDESC="boost: Peer-reviewed STL style libraries for C++"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+pic"

make_host() {
  cd tools/build/src/engine
    sh build.sh
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp bin.*/bjam $TOOLCHAIN/bin
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/$PKG_PYTHON_VERSION"
  export CXXFLAGS="$CXXFLAGS -I$SYSROOT_PREFIX/usr/include/$PKG_PYTHON_VERSION"
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=$TOOLCHAIN/bin/bjam \
                  --with-python=$TOOLCHAIN/bin/python \
                  --with-python-root=$SYSROOT_PREFIX/usr

  echo "using gcc : `$CC -v 2>&1  | tail -n 1 |awk '{print $3}'` : $CC  : <compileflags>\"$CFLAGS\" <linkflags>\"$LDFLAGS\" ;" \
    > tools/build/src/user-config.jam
  echo "using python : ${PKG_PYTHON_VERSION/#python} : $TOOLCHAIN : $SYSROOT_PREFIX/usr/include : $SYSROOT_PREFIX/usr/lib ;" \
    >> tools/build/src/user-config.jam
}

makeinstall_target() {
  $TOOLCHAIN/bin/bjam -d2 --ignore-site-config \
                          --layout=system \
                          --prefix=$SYSROOT_PREFIX/usr \
                          --toolset=gcc variant=release link=static runtime-link=static threading=multi address-model=64 \
                          --build-type=minimal \
                          --with-chrono \
                          --with-date_time \
                          --with-filesystem \
                          --with-iostreams \
                          --with-program_options \
                          --with-exception \
                          --with-python \
                          --with-atomic \
                          --with-random \
                          --with-regex -sICU_PATH="$SYSROOT_PREFIX/usr" \
                          --with-serialization \
                          --with-system \
                          --with-thread -j3 \
                          install
}
