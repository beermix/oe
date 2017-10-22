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

PKG_NAME="libtool"
PKG_VERSION="gg"
#PKG_SHA256="1c0e019e554fa9d094242f7e13af142e1b5c36ac36510f31ee3ea9c4c500ed9c"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/libtool/"
PKG_URL="https://dl.dropboxusercontent.com/s/eex8dmc1mzmnbq0/libtool-gg.tar.xz"
PKG_DEPENDS_HOST="ccache:host autoconf:host automake:host"
#PKG_NEED_UNPACK="$(get_pkg_directory gnulib)"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="libtool: Generic library support script"
PKG_LONGDESC="This is GNU Libtool, a generic library support script. Libtool hides the complexity of using shared libraries behind a consistent, portable interface."
PKG_AUTORECONF="no"

post_patch() {
  cd $PKG_BUILD
  export MAKEINFO=$TOOLCHAIN/bin/true
  ./bootstrap --no-git
}

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"
