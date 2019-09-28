# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="boost"
PKG_VERSION="1_71_0"
PKG_SHA256="d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee"
PKG_LICENSE="OSS"
PKG_SITE="http://www.boost.org/"
PKG_URL="$SOURCEFORGE_SRC/boost/boost/1.70.0/${PKG_NAME}_${PKG_VERSION}.tar.bz2"
PKG_URL="https://dl.bintray.com/boostorg/release/1.71.0/source/${PKG_NAME}_${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain boost:host Python2 zlib bzip2"
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
                          --with-thread -j3 \
                          install
}
