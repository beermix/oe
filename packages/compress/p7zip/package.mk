# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="p7zip"
PKG_VERSION="16.02"
PKG_SHA256="5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
PKG_LICENSE="GPL"
PKG_SITE="http://p7zip.sourceforge.net/"
PKG_URL="http://downloads.sourceforge.net/project/p7zip/p7zip/${PKG_VERSION}/p7zip_${PKG_VERSION}_src_all.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib"
#PKG_DEPENDS_HOST="zlib:host"
#PKG_TOOLCHAIN="cmake-make"
PKG_TOOLCHAIN="manual"

post_unpack() {
  cp $PKG_BUILD/makefile.linux_amd64_asm $PKG_BUILD/makefile.machine
}

make_host() {
  make CXX=$CXX CC=$CC 7z 7za
}

make_target() {
  make CXX=$CXX CC=$CC 7z 7za
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp bin/7za $TOOLCHAIN/bin
}

pre_configure_host() {
  export LDFLAGS="$LDFLAGS -s"
}

pre_configure_target() {
  export LDFLAGS="$LDFLAGS -s"
}

#configure_package() {
#  PKG_CMAKE_SCRIPT="$PKG_BUILD/CPP/7zip/CMAKE/CMakeLists.txt"
#  PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release -DCMAKE_VERBOSE_MAKEFILE=0"
#  PKG_CMAKE_OPTS_HOST="-DCMAKE_BUILD_TYPE=Release -DCMAKE_VERBOSE_MAKEFILE=0"
#}
