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

PKG_NAME="fribidi"
PKG_VERSION="1.0.2"
PKG_SHA256="bd6d1b530c4f6066f42461200ed6a31f2db8db208570ea4ccaab2b935e88832b"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://fribidi.freedesktop.org/"
PKG_URL="https://github.com/fribidi/fribidi/releases/download/v$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="devel"
PKG_SHORTDESC="fribidi: The Bidirectional Algorithm library"
PKG_LONGDESC="The library implements all of the algorithm as described in the Unicode Standard Annex #9, The Bidirectional Algorithm, http://www.unicode.org/unicode/reports/tr9/. FriBidi is exhautively tested against Bidi Reference Code, and due to our best knowledge, does not contain any conformance bugs."
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--disable-debug \
                           --disable-deprecated \
                           --enable-malloc \
                           --enable-charsets \
                           --with-gnu-ld \
                           --without-glib"

pre_configure_target() {
  export CFLAGS="$CFLAGS -DFRIBIDI_CHUNK_SIZE=4080"
}

post_makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/bin
    cp -f $PKG_DIR/scripts/fribidi-config $SYSROOT_PREFIX/usr/bin
    chmod +x $SYSROOT_PREFIX/usr/bin/fribidi-config

  rm -rf $INSTALL/usr/bin
}
