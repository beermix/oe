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

PKG_NAME="gettext"
PKG_VERSION="0.19.8.1"
PKG_SHA256="ff942af0e438ced4a8b0ea4b0b6e0d6d657157c5e2364de57baa279c1c125c43"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/s/gettext/"
PKG_URL="http://ftp.gnu.org/pub/gnu/gettext/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host libunistring:host icu:host libxml2:host"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="gettext: A program internationalization library and tools"
PKG_LONGDESC="This is the GNU gettext package. It is interesting for authors or maintainers of other packages or programs which they want to see internationalized. As one step the handling of messages in different languages should be implemented. For this task GNU gettext provides the needed tools and library functions."

post_unpack() {
  sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/examples$$//' $PKG_BUILD/gettext-tools/Makefile.in
  sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/tests$$//' $PKG_BUILD/gettext-runtime/Makefile.in
}

PKG_CONFIGURE_SCRIPT="gettext-tools/configure"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared \
                         --disable-rpath \
                         --with-gnu-ld \
                         --disable-java \
                         --disable-curses \
                         --with-included-libxml \
                         --disable-native-java \
                         --disable-csharp \
                         --without-emacs"
