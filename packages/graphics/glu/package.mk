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

PKG_NAME="glu"
PKG_VERSION="9.0.0"
PKG_SHA256="3d19cca9b26ec4048dd22e3d294acd43e080a3205a29ff47765bd514571ea8f9"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://cgit.freedesktop.org/mesa/glu/"
PKG_URL="http://cgit.freedesktop.org/mesa/glu/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain mesa"
PKG_SECTION="graphics"
PKG_SHORTDESC="glu: The OpenGL utility library"
PKG_LONGDESC="libglu is the The OpenGL utility library"
PKG_AUTORECONF="yes"

pre_configure_target() {
  CFLAGS=`echo $CFLAGS | sed -e "s|-D_FORTIFY_SOURCE=2||"`
}

PKG_CONFIGURE_OPTS_TARGET="--disable-silent-rules \
            --disable-debug \
            --disable-osmesa \
            --with-gnu-ld"
