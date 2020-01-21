# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bison"
PKG_VERSION="3.5.1"
PKG_SHA256="3e7e097bd9709a2d5e40e69446b74b149733b3de864fadb7a9b54eca7b2a4dd0"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/bison/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host flex:host"
PKG_LONGDESC="A general-purpose parser generator."

PKG_CONFIGURE_OPTS_HOST="--enable-threads=pth --disable-yacc --disable-rpath --with-gnu-ld"

post_configure_host() {
# The configure system causes Bison to be built without support for
# internationalization of error messages if a bison program is not already in
# $PATH. The following addition will correct this:
  echo '#define YYENABLE_NLS 1' >> lib/config.h
}

post_makeinstall_host() {
  cat > $TOOLCHAIN/bin/yacc << "EOF"
#!/bin/sh
exec bison -y "$@"
EOF

  chmod -v 755 $TOOLCHAIN/bin/yacc
}
