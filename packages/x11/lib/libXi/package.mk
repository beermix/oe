################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="libXi"
PKG_VERSION="1.7.9"
PKG_SHA256="c2e6b8ff84f9448386c1b5510a5cf5a16d788f76db018194dacdc200180faf45"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.x.org/"
PKG_URL="http://xorg.freedesktop.org/archive/individual/lib/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXfixes"
PKG_SECTION="x11/lib"
PKG_SHORTDESC="libxi: X11 Input extension library"
PKG_LONGDESC="LibXi provides an X Window System client interface to the XINPUT extension to the X protocol."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared \
                           --enable-malloc0returnsnull \
                           --disable-silent-rules \
                           --disable-docs \
                           --disable-specs \
                           --without-xmlto \
                           --without-fop \
                           --without-xsltproc \
                           --without-asciidoc \
                           --with-gnu-ld"
