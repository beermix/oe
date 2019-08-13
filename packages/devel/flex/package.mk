# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="flex"
PKG_VERSION="2.6.4"
PKG_SHA256="e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/westes/flex/releases"
PKG_URL="https://github.com/westes/flex/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host m4:host autotools:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A tool for generating programs that perform pattern-matching on text."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="ac_cv_path_M4=$BUILD/toolchain/bin/m4 \
			    ac_cv_func_reallocarray=no \
			    --enable-static \
			    --disable-shared \
			    --disable-rpath \
			    --with-gnu-ld \
			    --disable-doc"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_realloc_0_nonnull=yes \
                           ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_reallocarray=no \
                           --disable-doc \
                           --disable-program"

post_makeinstall_host() {
  cat > $TOOLCHAIN/bin/lex << "EOF"
#!/bin/sh
exec flex "$@"
EOF

  chmod -v 755 $TOOLCHAIN/bin/lex
}
