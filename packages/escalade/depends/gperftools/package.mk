################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2010-2011 Roman Weber (roman@openelec.tv)
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

PKG_NAME="gperftools"
PKG_VERSION="2.6.1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/gperftools/gperftools"
PKG_URL="https://github.com/gperftools/gperftools/releases/download/gperftools-$PKG_VERSION/gperftools-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION=""
PKG_SHORTDESC="Google Performance Tools"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
}

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared"

pre_configure_host() {
  export CFLAGS="$CFLAGS -fPIC -DPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC -DPIC"
}
