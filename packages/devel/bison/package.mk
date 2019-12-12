# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="bison"
PKG_VERSION="3.5"
PKG_SHA256="55e4a023b1b4ad19095a5f8279f0dc048fa29f970759cea83224a6d5e7a3a641"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/bison/?C=M;O=D"
PKG_URL="http://ftpmirror.gnu.org/bison/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host m4:host"
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
