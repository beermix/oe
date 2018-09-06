################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="flex"
PKG_VERSION="11b7512"
PKG_SITE="https://github.com/westes/flex/releases"
PKG_URL="https://github.com/westes/flex/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host m4:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="flex: Fast lexical analyzer generator"
PKG_LONGDESC="flex is a tool for generating programs that perform pattern-matching on text."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="ac_cv_path_M4=$TOOLCHAIN/bin/m4 \
			    ac_cv_func_reallocarray=no \
			    ac_cv_lib_util_getloadavg=no \
			    --enable-static --disable-shared --disable-rpath --with-gnu-ld"

post_makeinstall_host() {
  cat > $TOOLCHAIN/bin/lex << "EOF"
#!/bin/sh
exec flex "$@"
EOF

  chmod -v 755 $TOOLCHAIN/bin/lex
}

PKG_CONFIGURE_OPTS_TARGET="ac_cv_lib_util_getloadavg=no \
			      ac_cv_func_malloc_0_nonnull=yes \
			      ac_cv_func_realloc_0_nonnull=yes \
			      ac_cv_func_reallocarray=no"