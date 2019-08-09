# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="cmake"
PKG_VERSION="3.15.1"
PKG_SHA256="18dec548d8f8b04d53c60f9cedcebaa6762f8425339d1e2c889c383d3ccdd7f7"
PKG_LICENSE="BSD"
PKG_SITE="https://cmake.org/download/"
PKG_URL="http://www.cmake.org/files/v${PKG_VERSION%.*}/cmake-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host openssl:host"
PKG_LONGDESC="A cross-platform, open-source make system."
PKG_TOOLCHAIN="configure"

configure_host() {
  ../configure --prefix=$TOOLCHAIN \
               --no-qt-gui --no-system-libs \
               -- \
               -DCMAKE_C_FLAGS="-O2 -Wall -pipe -Wno-format-security" \
               -DCMAKE_CXX_FLAGS="-O2 -Wall -pipe -Wno-format-security" \
               -DCMAKE_EXE_LINKER_FLAGS="$HOST_LDFLAGS -s" \
               -DCMAKE_USE_OPENSSL=ON \
               -DBUILD_CursesDialog=0
}
