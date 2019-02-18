# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="bison"
PKG_VERSION="3.3.2"
PKG_SHA256="039ee45b61d95e5003e7e8376f9080001b4066ff357bde271b7faace53b9d804"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/bison/"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="A general-purpose parser generator."

PKG_CONFIGURE_OPTS_HOST="--enable-threads=pth --disable-rpath --with-gnu-ld"

post_configure_host() {
# The configure system causes Bison to be built without support for
# internationalization of error messages if a bison program is not already in
# $PATH. The following addition will correct this:
  echo '#define YYENABLE_NLS 1' >> lib/config.h
}
