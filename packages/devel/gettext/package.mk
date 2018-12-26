# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="gettext"
PKG_VERSION="0.19.8.1"
PKG_SHA256="ff942af0e438ced4a8b0ea4b0b6e0d6d657157c5e2364de57baa279c1c125c43"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/s/gettext/"
PKG_URL="http://ftp.gnu.org/pub/gnu/gettext/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host autotools:host libxml2:host bison:host"
PKG_DEPENDS_HOST="ccache:host m4:hostm4:host bison:host libxml2:host"
PKG_LONGDESC="A program internationalization library and tools."

post_unpack() {
  sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/examples$$//' $PKG_BUILD/gettext-tools/Makefile.in
  sed '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/tests$$//' $PKG_BUILD/gettext-runtime/Makefile.in
}

PKG_CONFIGURE_SCRIPT="gettext-tools/configure"

PKG_CONFIGURE_OPTS_HOST="--disable-java \
                         --disable-curses \
                         --disable-native-java \
                         --disable-csharp \
                         --without-emacs \
                         --disable-libasprintf \
                         --disable-acl \
                         --disable-openmp \
                         --disable-relocatable"
