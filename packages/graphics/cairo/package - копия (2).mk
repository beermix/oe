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

PKG_NAME="cairo"
PKG_VERSION="1.14.12"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://cairographics.org/snapshots/?C=M;O=D"
PKG_URL="https://cairographics.org/snapshots/cairo-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib freetype fontconfig libpng pixman"
PKG_SECTION="graphics"
PKG_SHORTDESC="cairo: Multi-platform 2D graphics library"
PKG_LONGDESC="Cairo is a vector graphics library with cross-device output support. Currently supported output targets include the X Window System and in-memory image buffers. PostScript and PDF file output is planned. Cairo is designed to produce identical output on all output media while taking advantage of display hardware acceleration when available."
PKG_TOOLCHAIN="configure" # ToDo

PKG_CONFIGURE_OPTS_TARGET="--disable-static --disable-gtk-doc --enable-xlib=yes --enable-xcb=yes --enable-ft=yes --enable-fc=yes --enable-gl --enable-xlib-xcb"