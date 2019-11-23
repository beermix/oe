# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="flex"
PKG_VERSION="2.6.4"
PKG_SHA256="e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
#PKG_VERSION="8b1fbf6"
#PKG_SHA256="f84828edd15f850aaf08ae271042ed8f653acacd5bdd4d8fb22a9b56b59c981a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/westes/flex/releases"
PKG_URL="https://github.com/westes/flex/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
#PKG_URL="https://github.com/westes/flex/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="ccache:host m4:host autotools:host bison:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A tool for generating programs that perform pattern-matching on text."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-shared --disable-doc"

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
