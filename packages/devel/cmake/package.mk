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

PKG_NAME="cmake"
PKG_VERSION="3.11.2"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://cmake.org/files/?C=M;O=D"
PKG_URL="https://cmake.org/files/v3.11/cmake-$PKG_VERSION-Linux-x86_64.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}-Linux-x86_64"
PKG_DEPENDS_HOST="ccache:host openssl:host bzip2:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="cmake: A cross-platform, open-source make system"
PKG_LONGDESC="CMake is used to control the software compilation process using simple platform and compiler independent configuration files. CMake generates native makefiles and workspaces that can be used in the compiler environment of your choice. CMake is quite sophisticated: it is possible to support complex environments requiring system configuration, preprocessor generation, code generation, and template instantiation."
PKG_TOOLCHAIN="manual"

post_unpack() {
  cp -r $PKG_BUILD/* $TOOLCHAIN/
  rm -rf $PKG_BUILD/*
}
