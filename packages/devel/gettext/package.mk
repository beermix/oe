# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gettext"
PKG_VERSION="0.20"
PKG_SHA256="5194991e786f1e98fe9682449a7630f03deea201c7f0d668eea28cd31a800dff"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/s/gettext/"
PKG_URL="http://ftp.gnu.org/pub/gnu/gettext/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host libxml2:host autotools:host"
PKG_LONGDESC="A program internationalization library and tools."
PKG_TOOLCHAIN="autotools"

post_unpack() {
  sed -i '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/examples$$//' $PKG_BUILD/gettext-tools/Makefile.in
  sed -i '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/tests$$//' $PKG_BUILD/gettext-runtime/Makefile.in
}

#pre_configure_host() {
#  cd $PKG_BUILD
#  rm -rf .$HOST_NAME
#}

configure_package() {
  PKG_CONFIGURE_SCRIPT="${PKG_BUILD}/gettext-tools/configure"

  PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared \
                           --disable-rpath \
                           --with-gnu-ld \
                           --disable-java \
                           --disable-curses \
                           --with-included-libxml=no \
                           --disable-native-java \
                           --disable-csharp \
                           --without-emacs"
}
