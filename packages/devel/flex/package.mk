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
PKG_VERSION="3c0ccc4"
PKG_SITE="http://flex.sourceforge.net/"
PKG_GIT_URL="https://github.com/westes/flex"
PKG_DEPENDS_HOST="ccache:host"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="flex: Fast lexical analyzer generator"
PKG_LONGDESC="flex is a tool for generating programs that perform pattern-matching on text."
PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-static --disable-shared --disable-rpath --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_HOST"

post_makeinstall_host() {
  cat > $ROOT/$TOOLCHAIN/bin/lex << "EOF"
#!/bin/sh
exec flex "$@"
EOF

  chmod -v 755 $ROOT/$TOOLCHAIN/bin/lex
}