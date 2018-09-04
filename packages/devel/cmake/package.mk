# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="cmake"
PKG_VERSION="3.12.1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://cmake.org/download/"
PKG_URL="http://www.cmake.org/files/v${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host openssl:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="cmake: A cross-platform, open-source make system"
PKG_LONGDESC="CMake is used to control the software compilation process using simple platform and compiler independent configuration files. CMake generates native makefiles and workspaces that can be used in the compiler environment of your choice. CMake is quite sophisticated: it is possible to support complex environments requiring system configuration, preprocessor generation, code generation, and template instantiation."
PKG_TOOLCHAIN="configure"

configure_host() {
  ../configure --prefix=$TOOLCHAIN \
               --no-qt-gui \
               -- \
               -DCMAKE_C_FLAGS="-O2 -Wall -pipe -Wno-format-security" \
               -DCMAKE_CXX_FLAGS="-O2 -Wall -pipe -Wno-format-security" \
               -DCMAKE_EXE_LINKER_FLAGS="$HOST_LDFLAGS -s" \
               -DCMAKE_USE_OPENSSL=ON \
               -DBUILD_CursesDialog=0 \
               -DCMAKE_USE_SYSTEM_LIBRARIES=1 \
               -DCMAKE_USE_SYSTEM_LIBRARY_JSONCPP=0 \
               -DCMAKE_USE_SYSTEM_LIBRARY_LIBUV=0 \
               -DCMAKE_USE_SYSTEM_LIBRARY_LIBRHASH=0 \
               -DKWSYS_CHAR_IS_SIGNED=1 \
               -DBUILD_CursesDialog=0 \
               -DKWSYS_LFS_WORKS=1
}
