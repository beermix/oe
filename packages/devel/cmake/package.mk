# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="cmake"
PKG_VERSION="3.13.0"
PKG_LICENSE="BSD"
PKG_SITE="https://cmake.org/download/"
PKG_URL="http://www.cmake.org/files/v${PKG_VERSION%.*}/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_SHORTDESC="cmake: A cross-platform, open-source make system"
PKG_TOOLCHAIN="configure"

configure_host() {
  ../configure --prefix=$TOOLCHAIN \
               --no-qt-gui --no-system-libs \
               -- \
               -DCMAKE_C_FLAGS="-O2 -Wall -pipe -Wno-format-security -fno-plt" \
               -DCMAKE_CXX_FLAGS="-O2 -Wall -pipe -Wno-format-security -fno-plt" \
               -DCMAKE_EXE_LINKER_FLAGS="$HOST_LDFLAGS -Wl,--as-needed,-z,relro,-z,now -s" \
               -DCMAKE_USE_OPENSSL=ON \
               -DBUILD_CursesDialog=0
}
