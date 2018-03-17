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

PKG_NAME="cunit"
PKG_VERSION="2.1-3-dfsg"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.mpfr.org/"
PKG_URL="http://192.168.1.200:8080/%2Fcunit-2.1-3-dfsg.tar.xz"
PKG_DEPENDS_HOST=""
PKG_SECTION="devel"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static --with-pic"
PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_TARGET"
