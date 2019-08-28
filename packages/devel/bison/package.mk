# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bison"
#PKG_VERSION="3.3.2"
#PKG_SHA256="039ee45b61d95e5003e7e8376f9080001b4066ff357bde271b7faace53b9d804"
PKG_VERSION="3.4.1"
PKG_SHA256="27159ac5ebf736dffd5636fd2cd625767c9e437de65baa63cb0de83570bd820d"
#PKG_VERSION="3.4"
#PKG_SHA256="6f3582cce1bb040fa09cfa238d6ee8643c03c79e34d0d203a7466b8cc1038efa"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/bison/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host"
PKG_LONGDESC="A general-purpose parser generator."

PKG_CONFIGURE_OPTS_HOST="--enable-threads=pth"

post_configure_host() {
# The configure system causes Bison to be built without support for
# internationalization of error messages if a bison program is not already in
# $PATH. The following addition will correct this:
  echo '#define YYENABLE_NLS 1' >> lib/config.h
}
