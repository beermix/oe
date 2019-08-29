# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gettext"
PKG_VERSION="0.20.1"
PKG_SHA256="66415634c6e8c3fa8b71362879ec7575e27da43da562c798a8a2f223e6e47f5c"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/s/gettext/"
PKG_URL="http://ftp.gnu.org/pub/gnu/gettext/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="A program internationalization library and tools."

PKG_CONFIGURE_OPTS_HOST="--disable-rpath \
			    --disable-java \
			    --disable-curses \
			    --with-included-libxml \
			    --with-included-libcroco \
			    --with-included-libunistring \
			    --with-included-glib \
			    --disable-native-java \
			    --without-included-gettext \
			    --without-emacs \
			    --disable-openmp \
			    --without-cvs \
			    --without-git"

post_configure() {
  sed -e 's/ -shared / -Wl,-O1,--as-needed\0/g' -i $PKG_BUILD/gettext-tools/libtool
  sed -e 's/ -shared / -Wl,-O1,--as-needed\0/g' -i $PKG_BUILD/gettext-runtime/libtool
  sed -e 's/ -shared / -Wl,-O1,--as-needed\0/g' -i $PKG_BUILD/gettext-runtime/libasprintf/libtool
}