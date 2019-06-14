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

PKG_NAME="webkitgtk"
PKG_VERSION="2.18.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://cgit.freedesktop.org/mesa/glu/"
PKG_URL="https://www.webkitgtk.org/releases/webkitgtk-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain harfbuzz icu"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="glu: The OpenGL utility library"
PKG_LONGDESC="libglu is the The OpenGL utility library"


PKG_CMAKE_OPTS_TARGET="-DENABLE_API_TESTS=OFF \
			  -DENABLE_GEOLOCATION=OFF \
			  -DENABLE_GTKDOC=OFF \
			  -DENABLE_INTROSPECTION=OFF \
			  -DENABLE_MINIBROWSER=ON \
			  -DENABLE_SPELLCHECK=ON \
			  -DUSE_LIBNOTIFY=OFF \
			  -DUSE_LIBHYPHEN=OFF"