# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="flex"
PKG_VERSION="8b1fbf6"
PKG_SHA256="f84828edd15f850aaf08ae271042ed8f653acacd5bdd4d8fb22a9b56b59c981a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/westes/flex"
PKG_URL="https://github.com/westes/flex/archive/${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host m4:host autotools:host gettext:host bison:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A tool for generating programs that perform pattern-matching on text."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-rpath --with-gnu-ld --disable-doc"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           --disable-program \
                           --disable-doc"

post_makeinstall_host() {
  cat > $TOOLCHAIN/bin/lex << "EOF"
#!/bin/sh
exec flex "$@"
EOF

  chmod -v 755 $TOOLCHAIN/bin/lex
}
