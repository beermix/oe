# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bison"
PKG_VERSION="3.4.1"
PKG_SHA256="27159ac5ebf736dffd5636fd2cd625767c9e437de65baa63cb0de83570bd820d"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/bison/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host"
PKG_LONGDESC="A general-purpose parser generator."

PKG_CONFIGURE_OPTS_HOST="--disable-rpath --with-gnu-ld"

post_configure_host() {
# The configure system causes Bison to be built without support for
# internationalization of error messages if a bison program is not already in
# $PATH. The following addition will correct this:
  echo '#define YYENABLE_NLS 1' >> lib/config.h
}
