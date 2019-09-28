# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="TexturePacker"
PKG_VERSION="0"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_DEPENDS_HOST="lzo:host libpng:host libjpeg-turbo:host giflib:host"
PKG_DEPENDS_UNPACK="kodi"
PKG_NEED_UNPACK="$(get_pkg_directory $MEDIACENTER)"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_SCRIPT="$(get_build_dir $MEDIACENTER)/tools/depends/native/TexturePacker/CMakeLists.txt"

PKG_CMAKE_OPTS_HOST="-DCORE_SOURCE_DIR=$(get_build_dir $MEDIACENTER) \
                     -Wno-dev"

pre_configure_host() {
  export CXXFLAGS="$CXXFLAGS -std=c++11 -DTARGET_POSIX -DTARGET_LINUX -D_LINUX -I$(get_build_dir $MEDIACENTER)/xbmc/linux"
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/bin
    cp TexturePacker $TOOLCHAIN/bin
}
